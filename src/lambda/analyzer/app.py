import gzip
import json
import os
import re
from collections import Counter
from datetime import datetime, timezone
from urllib.parse import unquote_plus

import boto3

S3 = boto3.client("s3")
SNS = boto3.client("sns")

IP_RE = re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b")
CRED_RE = re.compile(r"\[(?P<user>[^/\]]+)/(?P<pass>[^\]]+)\]")
CMD_RE = re.compile(r"\bCMD: (?P<cmd>.+)$")


def _safe_int(value, default):
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


THRESHOLD_TOTAL = _safe_int(os.getenv("THRESHOLD_TOTAL"), 20)
THRESHOLD_PER_IP = _safe_int(os.getenv("THRESHOLD_PER_IP"), 10)
SNS_TOPIC_ARN = os.getenv("SNS_TOPIC_ARN", "")


def _init_counters():
    return {
        "ip": Counter(),
        "user": Counter(),
        "pass": Counter(),
        "cmd": Counter(),
    }


def _parse_json_record(record, counters):
    counters["ip"].update([record.get("src_ip")]) if record.get("src_ip") else None
    if record.get("username"):
        counters["user"].update([record.get("username")])
    if record.get("password"):
        counters["pass"].update([record.get("password")])
    cmd = record.get("input") or record.get("command") or record.get("command_input")
    if cmd:
        counters["cmd"].update([cmd])


def _parse_text_line(line, counters):
    ip_match = IP_RE.search(line)
    if ip_match:
        counters["ip"].update([ip_match.group(0)])

    cred_match = CRED_RE.search(line)
    if cred_match:
        counters["user"].update([cred_match.group("user")])
        counters["pass"].update([cred_match.group("pass")])

    cmd_match = CMD_RE.search(line)
    if cmd_match:
        counters["cmd"].update([cmd_match.group("cmd").strip()])


def _format_top(counter, limit=5):
    items = counter.most_common(limit)
    if not items:
        return "none"
    return ", ".join([f"{key}={count}" for key, count in items])


def _log_json(payload):
    print(json.dumps(payload))


def _process_object(bucket, key):
    obj = S3.get_object(Bucket=bucket, Key=key)
    body = obj["Body"].read()

    if key.endswith(".gz"):
        body = gzip.decompress(body)

    text = body.decode("utf-8", errors="replace")

    counters = _init_counters()
    total_events = 0

    lines = text.splitlines()
    for line in lines:
        line = line.strip()
        if not line:
            continue

        if line.startswith("{"):
            try:
                record = json.loads(line)
                if isinstance(record, dict):
                    _parse_json_record(record, counters)
                total_events += 1
                continue
            except json.JSONDecodeError:
                pass

        _parse_text_line(line, counters)
        total_events += 1

    max_per_ip = max(counters["ip"].values(), default=0)
    alert = total_events > THRESHOLD_TOTAL or max_per_ip > THRESHOLD_PER_IP

    summary = {
        "bucket": bucket,
        "key": key,
        "total_events": total_events,
        "max_per_ip": max_per_ip,
        "top_ips": _format_top(counters["ip"]),
        "top_users": _format_top(counters["user"]),
        "top_passwords": _format_top(counters["pass"]),
        "top_commands": _format_top(counters["cmd"]),
        "threshold_total": THRESHOLD_TOTAL,
        "threshold_per_ip": THRESHOLD_PER_IP,
    }

    if alert and SNS_TOPIC_ARN:
        message = [
            "Cowrie suspicious activity detected",
            f"Bucket: {bucket}",
            f"Key: {key}",
            f"Total events: {total_events}",
            f"Max per IP: {max_per_ip}",
            f"Top IPs: {summary['top_ips']}",
            f"Top users: {summary['top_users']}",
            f"Top passwords: {summary['top_passwords']}",
            f"Top commands: {summary['top_commands']}",
            f"Timestamp: {datetime.now(timezone.utc).isoformat()}",
        ]
        SNS.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="DAMN-TEAMSSN Honeypot Alert",
            Message="\n".join(message),
        )
        summary["alert_sent"] = True
    else:
        summary["alert_sent"] = False

    _log_json({"level": "info", "message": "processed_log", **summary})


def lambda_handler(event, _context):
    records = event.get("Records", [])
    if not records:
        _log_json({"level": "warning", "message": "no_records"})
        return {"statusCode": 200, "body": "no_records"}

    for record in records:
        try:
            bucket = record["s3"]["bucket"]["name"]
            key = unquote_plus(record["s3"]["object"]["key"])
            _process_object(bucket, key)
        except Exception as exc:
            _log_json({
                "level": "warning",
                "message": "failed_to_process",
                "error": str(exc),
            })

    return {"statusCode": 200, "body": "ok"}
