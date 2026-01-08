#!/bin/bash
set -euo pipefail

AWS_REGION="${aws_region}"
S3_BUCKET="${s3_bucket_name}"
S3_PREFIX="cowrie/${resource_suffix}"
ENABLE_SSM="${enable_ssm}"
ADMIN_SSH_PORT="${admin_ssh_port}"

# Base packages
sudo dnf update -y
sudo dnf install -y git python3.11 python3.11-pip gcc libffi-devel openssl-devel make awscli cronie libcap

PYTHON_BIN="$(command -v python3.11 || true)"
if [ -z "$PYTHON_BIN" ]; then
  echo "python3.11 not found; Cowrie requires a supported Python version." >&2
  exit 1
fi

# Cowrie user and install
if ! id cowrie >/dev/null 2>&1; then
  sudo useradd --system --home-dir /opt/cowrie --shell /bin/bash cowrie
fi

sudo mkdir -p /opt/cowrie
sudo chown -R cowrie:cowrie /opt/cowrie

if [ ! -d /opt/cowrie/cowrie ]; then
  sudo -u cowrie git clone https://github.com/cowrie/cowrie /opt/cowrie/cowrie
fi

if [ ! -d /opt/cowrie/cowrie-env ]; then
  sudo -u cowrie "$PYTHON_BIN" -m venv /opt/cowrie/cowrie-env
fi

sudo -u cowrie /opt/cowrie/cowrie-env/bin/pip install --upgrade pip
sudo -u cowrie /opt/cowrie/cowrie-env/bin/pip install --upgrade -r /opt/cowrie/cowrie/requirements.txt
# Install Cowrie entrypoint into the venv so the "cowrie" script exists.
sudo -u cowrie /opt/cowrie/cowrie-env/bin/pip install -e /opt/cowrie/cowrie

if [ ! -f /opt/cowrie/cowrie/etc/cowrie.cfg ]; then
  sudo -u cowrie cp /opt/cowrie/cowrie/etc/cowrie.cfg.dist /opt/cowrie/cowrie/etc/cowrie.cfg
fi

sudo awk '
BEGIN{added=0}
{
  if ($0 ~ /^\[ssh\]/) {
    print
    if (!added) {
      print "listen_endpoints = tcp:22:interface=0.0.0.0"
      added=1
    }
    next
  }
  if ($0 ~ /^[[:space:]]*listen_endpoints[[:space:]]*=/) next
  print
}
END{
  if (!added) {
    print ""
    print "[ssh]"
    print "listen_endpoints = tcp:22:interface=0.0.0.0"
  }
}
' /opt/cowrie/cowrie/etc/cowrie.cfg > /tmp/cowrie.cfg
sudo mv /tmp/cowrie.cfg /opt/cowrie/cowrie/etc/cowrie.cfg
sudo chown cowrie:cowrie /opt/cowrie/cowrie/etc/cowrie.cfg

# Allow Cowrie to bind port 22 without running as root
# Localizar el binario real de python3 al que apunta el venv
REAL_PYTHON=$(readlink -f /opt/cowrie/cowrie-env/bin/python3)

# Aplicar la capacidad al binario real
sudo setcap 'cap_net_bind_service=+ep' "$REAL_PYTHON"

# Systemd service
cat <<'SERVICE' | sudo tee /etc/systemd/system/cowrie.service >/dev/null
[Unit]
Description=Cowrie SSH Honeypot
After=network.target

[Service]
Type=simple
User=cowrie
Group=cowrie
WorkingDirectory=/opt/cowrie/cowrie
Environment="PATH=/opt/cowrie/cowrie-env/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Environment="PYTHONPATH=/opt/cowrie/cowrie/src"
ExecStart=/opt/cowrie/cowrie-env/bin/twistd --umask 0022 --nodaemon --pidfile= -l - cowrie
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload

# SSM vs SSH admin access
if [ "$ENABLE_SSM" = "true" ]; then
  sudo dnf install -y amazon-ssm-agent
  sudo systemctl enable --now amazon-ssm-agent
  sudo systemctl disable --now sshd
else
  if grep -q "^#Port 22" /etc/ssh/sshd_config; then
    sudo sed -i "s/^#Port 22/Port $ADMIN_SSH_PORT/" /etc/ssh/sshd_config
  fi
  if ! grep -q "^Port $ADMIN_SSH_PORT" /etc/ssh/sshd_config; then
    echo "Port $ADMIN_SSH_PORT" | sudo tee -a /etc/ssh/sshd_config >/dev/null
  fi
  sudo systemctl restart sshd
fi

sudo systemctl enable --now cowrie

# S3 log sync script
LOG_DIR="/opt/cowrie/cowrie/var/log/cowrie"
cat <<EOF | sudo tee /usr/local/bin/cowrie_s3_sync.sh >/dev/null
#!/bin/bash
set -euo pipefail
if [ ! -d "$LOG_DIR" ]; then
  exit 0
fi
aws s3 sync "$LOG_DIR" "s3://$S3_BUCKET/$S3_PREFIX/" --region "$AWS_REGION" --no-progress
EOF

sudo chmod +x /usr/local/bin/cowrie_s3_sync.sh

cat <<'EOF' | sudo tee /etc/cron.d/cowrie_s3_sync >/dev/null
*/5 * * * * root /usr/local/bin/cowrie_s3_sync.sh
EOF

sudo systemctl enable --now crond
