locals {
  name_prefix = "${var.project_prefix}-${var.resource_suffix}"
  s3_prefix   = "cowrie/${var.resource_suffix}"
  use_existing_profile = var.existing_instance_profile_name != ""
}

resource "aws_security_group" "honeypot" {
  name        = "${local.name_prefix}-sg"
  description = "Honeypot security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Honeypot SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.enable_telnet ? [1] : []
    content {
      description = "Honeypot Telnet"
      from_port   = 23
      to_port     = 23
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.enable_ssm ? [] : [1]
    content {
      description = "Admin SSH"
      from_port   = var.admin_ssh_port
      to_port     = var.admin_ssh_port
      protocol    = "tcp"
      cidr_blocks = [var.allowed_admin_cidr]
    }
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-sg"
  })
}

# IAM role for EC2 to push logs to S3 (and SSM if enabled)
data "aws_iam_policy_document" "assume_role" {
  count = local.use_existing_profile ? 0 : 1

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "honeypot" {
  count              = local.use_existing_profile ? 0 : 1
  name               = "${local.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-role"
  })
}

data "aws_iam_policy_document" "s3_logs" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload"
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/${local.s3_prefix}/*"]
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${local.s3_prefix}/*"]
    }
  }
}

resource "aws_iam_role_policy" "s3_logs" {
  count  = local.use_existing_profile ? 0 : 1
  name   = "${local.name_prefix}-s3-logs"
  role   = aws_iam_role.honeypot[0].name
  policy = data.aws_iam_policy_document.s3_logs.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = local.use_existing_profile || !var.enable_ssm ? 0 : 1
  role       = aws_iam_role.honeypot[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "honeypot" {
  count = local.use_existing_profile ? 0 : 1
  name = "${local.name_prefix}-profile"
  role = aws_iam_role.honeypot[0].name

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-profile"
  })
}

resource "aws_instance" "honeypot" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.honeypot.id]
  associate_public_ip_address = true
  iam_instance_profile        = local.use_existing_profile ? var.existing_instance_profile_name : aws_iam_instance_profile.honeypot[0].name
  key_name                    = var.key_name != "" ? var.key_name : null
  user_data = templatefile("${path.module}/user_data.sh", {
    aws_region      = var.aws_region
    s3_bucket_name  = var.s3_bucket_name
    resource_suffix = var.resource_suffix
    enable_ssm      = var.enable_ssm
    admin_ssh_port  = var.admin_ssh_port
  })

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-cowrie"
  })
}

resource "aws_eip" "honeypot" {
  domain   = "vpc"
  instance = aws_instance.honeypot.id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-eip"
  })
}
