# Configura el perfil del AWS CLI (credenciales temporales de laboratorio).
aws configure --profile <aws_profile>

# Define region y formato para el perfil.
aws configure set region us-east-1 --profile <aws_profile>
aws configure set output json --profile <aws_profile>

# Despliega/actualiza la infraestructura con tu tfvars.
scripts\up.ps1 -Env <env>

# Obtiene public_ip, instance_id, s3_bucket, etc.
scripts\show_outputs.ps1 -Env <env>

# Genera intento controlado para que Cowrie escriba logs.
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=5 -p 22 fakeuser@<public_ip>

# Fuerza el sync de logs a S3 (sin esperar el cron).
aws ssm send-command --instance-ids <instance_id> --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile <aws_profile>

# Verifica que los logs llegaron al bucket.
aws s3 ls s3://<s3_bucket>/cowrie/<suffix>/ --profile <aws_profile>

# Confirma ejecucion de Lambda y alerta.
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --since 10m --profile <aws_profile>

# Fuerza alerta (subir eventos hasta superar umbral).
1..10 | ForEach-Object { ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=3 -p 22 fakeuser@<public_ip> }
aws ssm send-command --instance-ids <instance_id> --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile <aws_profile>
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --since 10m --profile <aws_profile>

# Destruye toda la infraestructura.
scripts\down.ps1 -Env <env>

# Comandos reales (copiar y pegar en orden)
aws configure --profile alonso
aws configure set region us-east-1 --profile alonso
aws configure set output json --profile alonso
scripts\up.ps1 -Env alonso
scripts\show_outputs.ps1 -Env alonso
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=5 -p 22 fakeuser@34.231.99.168
aws ssm send-command --instance-ids i-0915c3349f9182dc0 --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile alonso
aws s3 ls s3://proy-damn-teamssn-logs-amm2-851725275441/cowrie/amm2/ --profile alonso
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-amm2 --since 10m --profile alonso
1..10 | ForEach-Object { ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=3 -p 22 fakeuser@34.231.99.168 }
aws ssm send-command --instance-ids i-0915c3349f9182dc0 --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile alonso
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-amm2 --since 10m --profile alonso
scripts\down.ps1 -Env alonso
