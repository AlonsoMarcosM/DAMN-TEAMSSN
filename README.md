# DAMN-TEAMSSN - Hito 1 Honeypot

Infraestructura reproducible con Terraform para un honeypot en AWS: EC2 con Cowrie, logs en S3, Lambda para analisis y alertas por SNS, y alarmas CloudWatch.

## Requisitos
- Terraform >= 1.5
- AWS CLI
- PowerShell (Windows)
- Cuenta AWS laboratorio (region us-east-1)

## Estructura del repo
- `infra/` Terraform raiz y modulos
- `src/lambda/analyzer/` codigo Lambda
- `scripts/` automatizacion PowerShell
- `envs/` tfvars de ejemplo y plantilla de credenciales
- `docs/` documentacion

## Credenciales (no se versionan)
Plantilla de ejemplo: `envs/aws_credentials.example`.

Credenciales reales:
- Windows: `C:\Users\<user>\.aws\credentials`
- Linux/Mac: `~/.aws/credentials`

Crear/usar perfiles:
```
aws configure --profile <nombre>
```

## Configuracion por persona
1) Copia un ejemplo:
   - `envs/alonso.tfvars.example` -> `envs/alonso.tfvars`
2) Edita valores: `resource_suffix`, `admin_email`, `allowed_admin_cidr`, etc.

## Despliegue
```
.\scripts\up.ps1 -Env alonso
```

## Verificacion
- Confirma la suscripcion SNS en tu email.
- Revisa outputs: `public_ip` y `s3_bucket`.
- Prueba controlada (solo en tu entorno):
  - `ssh -p 22 fakeuser@<public_ip>`

## Logs y alertas
- S3: `s3://proy-damn-teamssn-logs-<suffix>/cowrie/<suffix>/`
- Lambda logs: `aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --follow`
- Alertas: SNS envia email cuando supera umbrales.

## Actualizar Lambda sin Terraform
```
.\scripts\deploy_lambda_analyzer.ps1 -Env alonso
```

## Apagar infraestructura
```
.\scripts\down.ps1 -Env alonso
```

## Notas
- Si el AMI por defecto no es valido, establece `ami_id = ""` en tu tfvars para usar el ultimo Amazon Linux 2023.
- Recomendado: `enable_ssm = true` y no abrir SSH administrativo.
- Tags obligatorios: Project=DAMN-TEAMSSN, Owner=<suffix>, Env=dev.
