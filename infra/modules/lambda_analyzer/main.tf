data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../src/lambda/analyzer"
  output_path = "${path.root}/../build/lambda_analyzer.zip"
}

locals {
  use_existing_role = var.existing_role_arn != ""
}

data "aws_iam_policy_document" "assume_role" {
  count = local.use_existing_role ? 0 : 1

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  count              = local.use_existing_role ? 0 : 1
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json

  tags = merge(var.tags, {
    Name = "${var.function_name}-role"
  })
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = [
      "${var.s3_bucket_arn}/cowrie/*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["sns:Publish"]
    resources = [var.sns_topic_arn]
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  count  = local.use_existing_role ? 0 : 1
  name   = "${var.function_name}-policy"
  role   = aws_iam_role.lambda[0].name
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_lambda_function" "analyzer" {
  function_name    = var.function_name
  description      = "Analyze Cowrie logs from S3 and send SNS alerts"
  role             = local.use_existing_role ? var.existing_role_arn : aws_iam_role.lambda[0].arn
  handler          = "app.lambda_handler"
  runtime          = "python3.11"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      SNS_TOPIC_ARN    = var.sns_topic_arn
      THRESHOLD_TOTAL  = tostring(var.threshold_total)
      THRESHOLD_PER_IP = tostring(var.threshold_per_ip)
    }
  }

  tags = merge(var.tags, {
    Name = var.function_name
  })
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.analyzer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "s3_trigger" {
  bucket = var.s3_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.analyzer.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "cowrie/"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
