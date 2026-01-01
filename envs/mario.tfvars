aws_profile = "mario"
aws_region  = "us-east-1"
az          = "us-east-1a"
resource_suffix = "mpg"

admin_email = "mario.panos2@alu.uclm.es"
allowed_admin_cidr = "89.38.181.36/32"

instance_type = "t3.micro"
ami_id        = ""
key_name      = ""

existing_instance_profile_name = "LabInstanceProfile"
existing_lambda_role_arn       = "arn:aws:iam::889274907256:role/LabRole"

threshold_total   = 20
threshold_per_ip  = 10
s3_log_expire_days = 30
enable_ssm         = true
