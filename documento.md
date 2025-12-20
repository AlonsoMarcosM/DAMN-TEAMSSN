# Guia de ejecucion y uso

Este documento resume como preparar el entorno, desplegar la infraestructura y operar el honeypot.

## Requisitos
- Terraform >= 1.5
- AWS CLI
- PowerShell (Windows)
- Cuenta AWS laboratorio en us-east-1

## Credenciales (no se versionan)
- Plantilla: `envs/aws_credentials.example`
- Windows: `C:\Users\<user>\.aws\credentials`
- Linux/Mac: `~/.aws/credentials`

Crear un perfil:
```
aws configure --profile <nombre>
```

## Configuracion por persona
1) Copia un ejemplo de tfvars:
   - `envs/alonso.tfvars.example` -> `envs/alonso.tfvars`
2) Edita:
   - `resource_suffix`, `admin_email`, `allowed_admin_cidr`
   - `enable_ssm`, `threshold_total`, `threshold_per_ip`, etc.

## Despliegue
```
.\scripts\up.ps1 -Env alonso
```

## Verificacion
- Confirma la suscripcion SNS en tu email.
- Revisa outputs de Terraform: `public_ip`, `s3_bucket`, `lambda_name`.
- Prueba controlada (solo desde tu entorno):
  - `ssh -p 22 fakeuser@<public_ip>`

## Logs y alertas
- S3: `s3://proy-damn-teamssn-logs-<suffix>/cowrie/<suffix>/`
- Lambda logs:
```
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --follow
```

## Actualizar solo la Lambda
```
.\scripts\deploy_lambda_analyzer.ps1 -Env alonso
```

## Apagar infraestructura
```
.\scripts\down.ps1 -Env alonso
```

## Notas
- Si el AMI por defecto no funciona, pon `ami_id = ""` en tu tfvars para usar Amazon Linux 2023.
- Si desactivas SSM, el admin SSH usa el puerto 22222 y se restringe por `allowed_admin_cidr`.
