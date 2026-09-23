# DAMN-TEAMSSN - Honeypot en AWS (documentacion completa)

> **Despliegue público:** [Abrir despliegue](https://alonsomarcosm.github.io/DAMN-TEAMSSN/)

![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A5%201.5-844FBA?logo=terraform&logoColor=white)
![AWS provider](https://img.shields.io/badge/AWS%20provider-~%3E%205.0-FF9900?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI%2BPHBhdGggZmlsbD0iI2ZmZiIgZD0iTTYuOCAxMHEwMC40MC4xMC43YzAuMTAuMjAuMTAuNDAuMzAuNmMwMC4xMC4xMC4xMC4xMC4ycTAwLjEgLTAuMjAuMmwtMC41MC4zYTAuNDAuNCAwIDAgMSAtMC4yMC4xcS0wLjEwIC0wLjIgLTAuMWEyLjUgMi41IDAgMCAxIC0wLjMgLTAuNGE2IDYgMCAwIDEgLTAuMiAtMC41cS0wLjkgMS4xIC0yLjMgMS4xYy0wLjcgMCAtMS4yIC0wLjIgLTEuNiAtMC42cS0wLjYgLTAuNiAtMC42IC0xLjVjMCAtMC43MC4yIC0xLjIwLjcgLTEuNmMwLjUgLTAuNCAxLjEgLTAuNiAyIC0wLjZjMC4zIDAgMC42MDAuODAuMWMwLjMwMC42MC4xMC45MC4ydi0wLjZxMCAtMC45IC0wLjQgLTEuM2MtMC4zIC0wLjIgLTAuNyAtMC40IC0xLjMgLTAuNGMtMC4zIDAgLTAuNjAgLTAuOTAuMXEtMC40MC4xIC0wLjkwLjNhMiAyIDAgMCAxIC0wLjMwLjFhMC41MC41IDAgMCAxIC0wLjEwcS0wLjIwIC0wLjIgLTAuMnYtMC40YzAgLTAuMTAgLTAuMjAuMSAtMC4zYTAuNjAuNiAwIDAgMSAwLjIgLTAuMmE0LjYgNC42IDAgMCAxIDEgLTAuNGE0LjggNC44IDAgMCAxIDEuMiAtMC4yYzEgMCAxLjYwLjIgMi4xMC42cTAuNzAuNjAuNyAydjIuNnptLTMuMiAxLjJjMC4zIDAgMC41MDAuOCAtMC4xYTEuOCAxLjggMCAwIDAgMC44IC0wLjVhMS4zIDEuMyAwIDAgMCAwLjMgLTAuNWMwIC0wLjIwLjEgLTAuNDAuMSAtMC43di0wLjNhNyA3IDAgMCAwIC0wLjcgLTAuMWE2IDYgMCAwIDAgLTAuNzBjLTAuNSAwIC0wLjkwLjEgLTEuMjAuM2MtMC4zMC4yIC0wLjQwLjUgLTAuNDAuOWMwIDAuNDAuMTAuNzAuMzAuOGMwLjIwLjIwLjUwLjMwLjgwLjNtNi40MC45Yy0wLjEgMCAtMC4yMCAtMC4zIC0wLjFjLTAuMTAgLTAuMSAtMC4yIC0wLjIgLTAuM0w3LjYgNS42YTEuNCAxLjQgMCAwIDEgLTAuMSAtMC4zYzAgLTAuMTAuMSAtMC4yMC4yIC0wLjJoMC44cTAuMjAwLjMwLjFjMC4xMDAuMTAuMjAuMjAuM2wxLjMgNS4zbDEuMiAtNS4zcTAuMSAtMC4yMC4yIC0wLjNhMC42MC42IDAgMCAxIDAuMyAtMC4xaDAuNmMwLjIgMCAwLjMwMC4zMC4xYzAuMTAwLjEwLjIwLjIwLjNsMS4zIDUuM2wxLjQgLTUuM3EwLjEgLTAuMjAuMiAtMC4zYTAuNTAuNSAwIDAgMSAwLjMgLTAuMWgwLjdjMC4xIDAgMC4yMC4xMC4yMC4yYzAgMDAwLjEwMC4xYTEgMSAwIDAgMSAtMC4xMC4ybC0xLjkgNi4ycS0wLjEwLjIgLTAuMjAuM2EwLjUwLjUgMCAwIDEgLTAuMzAuMWgtMC43Yy0wLjIgMCAtMC4zMCAtMC4zIC0wLjFjLTAuMSAtMC4xIC0wLjEgLTAuMiAtMC4xIC0wLjNsLTEuMiAtNS4xbC0xLjIgNS4xYzAwLjIgLTAuMTAuMyAtMC4xMC4zYy0wLjEwLjEgLTAuMjAuMSAtMC4zMC4xem0xMC4zMC4yYy0wLjQgMCAtMC44MCAtMS4yIC0wLjFjLTAuNCAtMC4xIC0wLjcgLTAuMiAtMC45IC0wLjNjLTAuMSAtMC4xIC0wLjIgLTAuMiAtMC4yIC0wLjJhMC42MC42IDAgMCAxMCAtMC4ydi0wLjRjMCAtMC4yMC4xIC0wLjIwLjIgLTAuMnEwLjEgMCAwLjEwYzAwMC4xMDAuMjAuMXEwLjQwLjIwLjkwLjNjMC4zMC4xMC42MC4xMTAuMWMwLjUgMCAwLjkgLTAuMSAxLjIgLTAuM2EwLjkwLjkgMCAwIDAgMC40IC0wLjhhMC44MC44IDAgMCAwIC0wLjIgLTAuNmMtMC4xIC0wLjIgLTAuNCAtMC4zIC0wLjggLTAuNGwtMS4yIC0wLjRjLTAuNiAtMC4yIC0xIC0wLjUgLTEuMyAtMC44YTEuOSAxLjkgMCAwIDEgLTAuNCAtMS4ycTAgLTAuNTAuMiAtMC45YzAuMSAtMC4zMC4zIC0wLjUwLjYgLTAuN2MwLjIgLTAuMjAuNSAtMC4zMC44IC0wLjRjMC4zIC0wLjEwLjcgLTAuMSAxIC0wLjFjMC4yIDAgMC40MDAuNTBjMC4yMDAuNDAuMTAuNTAuMXEwLjIwLjEwLjUwLjFxMC4yMC4xMC4zMC4xYTAuNzAuNyAwIDAgMSAwLjIwLjJhMC40MC40IDAgMCAxIDAuMTAuM3YwLjRxMDAuMyAtMC4yMC4zYTAuODAuOCAwIDAgMSAtMC4zIC0wLjFhMy43IDMuNyAwIDAgMCAtMS41IC0wLjNjLTAuNSAwIC0wLjgwLjEgLTEuMTAuMnMtMC40MC40IC0wLjQwLjdjMCAwLjIwLjEwLjQwLjIwLjZjMC4yMC4yMC41MC4zMC45MC40bDEuMTAuNGMwLjYwLjIxMC40IDEuMjAuOHMwLjQwLjcwLjQgMS4xYzAgMC4zIC0wLjEwLjcgLTAuMjAuOWEyLjIgMi4yIDAgMCAxIC0wLjYwLjdjLTAuMjAuMiAtMC41MC4zIC0wLjkwLjRjLTAuNDAuMSAtMC43MC4yIC0xLjEwLjJtMS41IDMuOWMtMi42IDEuOSAtNi40IDMgLTkuNyAzYy00LjYgMCAtOC43IC0xLjcgLTExLjkgLTQuNWMtMC4yIC0wLjIwIC0wLjUwLjMgLTAuNGMzLjQgMiA3LjYgMy4yIDExLjkgMy4yYzIuOSAwIDYuMSAtMC42IDkuMSAtMS45YzAuNCAtMC4yMC44MC4zMC40MC42bTEuMSAtMS4yYy0wLjMgLTAuNCAtMi4yIC0wLjIgLTMuMSAtMC4xYy0wLjMwIC0wLjMgLTAuMiAtMC4xIC0wLjRjMS41IC0xLjEgNCAtMC43IDQuMyAtMC40YzAuMzAuNCAtMC4xIDIuOCAtMS41IDRjLTAuMjAuMiAtMC40MC4xIC0wLjMgLTAuMmMwLjMgLTAuOCAxIC0yLjYwLjcgLTMiLz48L3N2Zz4%3D)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20S3%20%7C%20Lambda%20%7C%20SNS%20%7C%20CloudWatch%20%7C%20SSM-FF9900?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI%2BPHBhdGggZmlsbD0iI2ZmZiIgZD0iTTYuOCAxMHEwMC40MC4xMC43YzAuMTAuMjAuMTAuNDAuMzAuNmMwMC4xMC4xMC4xMC4xMC4ycTAwLjEgLTAuMjAuMmwtMC41MC4zYTAuNDAuNCAwIDAgMSAtMC4yMC4xcS0wLjEwIC0wLjIgLTAuMWEyLjUgMi41IDAgMCAxIC0wLjMgLTAuNGE2IDYgMCAwIDEgLTAuMiAtMC41cS0wLjkgMS4xIC0yLjMgMS4xYy0wLjcgMCAtMS4yIC0wLjIgLTEuNiAtMC42cS0wLjYgLTAuNiAtMC42IC0xLjVjMCAtMC43MC4yIC0xLjIwLjcgLTEuNmMwLjUgLTAuNCAxLjEgLTAuNiAyIC0wLjZjMC4zIDAgMC42MDAuODAuMWMwLjMwMC42MC4xMC45MC4ydi0wLjZxMCAtMC45IC0wLjQgLTEuM2MtMC4zIC0wLjIgLTAuNyAtMC40IC0xLjMgLTAuNGMtMC4zIDAgLTAuNjAgLTAuOTAuMXEtMC40MC4xIC0wLjkwLjNhMiAyIDAgMCAxIC0wLjMwLjFhMC41MC41IDAgMCAxIC0wLjEwcS0wLjIwIC0wLjIgLTAuMnYtMC40YzAgLTAuMTAgLTAuMjAuMSAtMC4zYTAuNjAuNiAwIDAgMSAwLjIgLTAuMmE0LjYgNC42IDAgMCAxIDEgLTAuNGE0LjggNC44IDAgMCAxIDEuMiAtMC4yYzEgMCAxLjYwLjIgMi4xMC42cTAuNzAuNjAuNyAydjIuNnptLTMuMiAxLjJjMC4zIDAgMC41MDAuOCAtMC4xYTEuOCAxLjggMCAwIDAgMC44IC0wLjVhMS4zIDEuMyAwIDAgMCAwLjMgLTAuNWMwIC0wLjIwLjEgLTAuNDAuMSAtMC43di0wLjNhNyA3IDAgMCAwIC0wLjcgLTAuMWE2IDYgMCAwIDAgLTAuNzBjLTAuNSAwIC0wLjkwLjEgLTEuMjAuM2MtMC4zMC4yIC0wLjQwLjUgLTAuNDAuOWMwIDAuNDAuMTAuNzAuMzAuOGMwLjIwLjIwLjUwLjMwLjgwLjNtNi40MC45Yy0wLjEgMCAtMC4yMCAtMC4zIC0wLjFjLTAuMTAgLTAuMSAtMC4yIC0wLjIgLTAuM0w3LjYgNS42YTEuNCAxLjQgMCAwIDEgLTAuMSAtMC4zYzAgLTAuMTAuMSAtMC4yMC4yIC0wLjJoMC44cTAuMjAwLjMwLjFjMC4xMDAuMTAuMjAuMjAuM2wxLjMgNS4zbDEuMiAtNS4zcTAuMSAtMC4yMC4yIC0wLjNhMC42MC42IDAgMCAxIDAuMyAtMC4xaDAuNmMwLjIgMCAwLjMwMC4zMC4xYzAuMTAwLjEwLjIwLjIwLjNsMS4zIDUuM2wxLjQgLTUuM3EwLjEgLTAuMjAuMiAtMC4zYTAuNTAuNSAwIDAgMSAwLjMgLTAuMWgwLjdjMC4xIDAgMC4yMC4xMC4yMC4yYzAgMDAwLjEwMC4xYTEgMSAwIDAgMSAtMC4xMC4ybC0xLjkgNi4ycS0wLjEwLjIgLTAuMjAuM2EwLjUwLjUgMCAwIDEgLTAuMzAuMWgtMC43Yy0wLjIgMCAtMC4zMCAtMC4zIC0wLjFjLTAuMSAtMC4xIC0wLjEgLTAuMiAtMC4xIC0wLjNsLTEuMiAtNS4xbC0xLjIgNS4xYzAwLjIgLTAuMTAuMyAtMC4xMC4zYy0wLjEwLjEgLTAuMjAuMSAtMC4zMC4xem0xMC4zMC4yYy0wLjQgMCAtMC44MCAtMS4yIC0wLjFjLTAuNCAtMC4xIC0wLjcgLTAuMiAtMC45IC0wLjNjLTAuMSAtMC4xIC0wLjIgLTAuMiAtMC4yIC0wLjJhMC42MC42IDAgMCAxMCAtMC4ydi0wLjRjMCAtMC4yMC4xIC0wLjIwLjIgLTAuMnEwLjEgMCAwLjEwYzAwMC4xMDAuMjAuMXEwLjQwLjIwLjkwLjNjMC4zMC4xMC42MC4xMTAuMWMwLjUgMCAwLjkgLTAuMSAxLjIgLTAuM2EwLjkwLjkgMCAwIDAgMC40IC0wLjhhMC44MC44IDAgMCAwIC0wLjIgLTAuNmMtMC4xIC0wLjIgLTAuNCAtMC4zIC0wLjggLTAuNGwtMS4yIC0wLjRjLTAuNiAtMC4yIC0xIC0wLjUgLTEuMyAtMC44YTEuOSAxLjkgMCAwIDEgLTAuNCAtMS4ycTAgLTAuNTAuMiAtMC45YzAuMSAtMC4zMC4zIC0wLjUwLjYgLTAuN2MwLjIgLTAuMjAuNSAtMC4zMC44IC0wLjRjMC4zIC0wLjEwLjcgLTAuMSAxIC0wLjFjMC4yIDAgMC40MDAuNTBjMC4yMDAuNDAuMTAuNTAuMXEwLjIwLjEwLjUwLjFxMC4yMC4xMC4zMC4xYTAuNzAuNyAwIDAgMSAwLjIwLjJhMC40MC40IDAgMCAxIDAuMTAuM3YwLjRxMDAuMyAtMC4yMC4zYTAuODAuOCAwIDAgMSAtMC4zIC0wLjFhMy43IDMuNyAwIDAgMCAtMS41IC0wLjNjLTAuNSAwIC0wLjgwLjEgLTEuMTAuMnMtMC40MC40IC0wLjQwLjdjMCAwLjIwLjEwLjQwLjIwLjZjMC4yMC4yMC41MC4zMC45MC40bDEuMTAuNGMwLjYwLjIxMC40IDEuMjAuOHMwLjQwLjcwLjQgMS4xYzAgMC4zIC0wLjEwLjcgLTAuMjAuOWEyLjIgMi4yIDAgMCAxIC0wLjYwLjdjLTAuMjAuMiAtMC41MC4zIC0wLjkwLjRjLTAuNDAuMSAtMC43MC4yIC0xLjEwLjJtMS41IDMuOWMtMi42IDEuOSAtNi40IDMgLTkuNyAzYy00LjYgMCAtOC43IC0xLjcgLTExLjkgLTQuNWMtMC4yIC0wLjIwIC0wLjUwLjMgLTAuNGMzLjQgMiA3LjYgMy4yIDExLjkgMy4yYzIuOSAwIDYuMSAtMC42IDkuMSAtMS45YzAuNCAtMC4yMC44MC4zMC40MC42bTEuMSAtMS4yYy0wLjMgLTAuNCAtMi4yIC0wLjIgLTMuMSAtMC4xYy0wLjMwIC0wLjMgLTAuMiAtMC4xIC0wLjRjMS41IC0xLjEgNCAtMC43IDQuMyAtMC40YzAuMzAuNCAtMC4xIDIuOCAtMS41IDRjLTAuMjAuMiAtMC40MC4xIC0wLjMgLTAuMmMwLjMgLTAuOCAxIC0yLjYwLjcgLTMiLz48L3N2Zz4%3D)
![Cowrie](https://img.shields.io/badge/Cowrie-SSH%20honeypot-2F4F4F)
![Python](https://img.shields.io/badge/Lambda-Python%203.11-3776AB?logo=python&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-up%20%2F%20down-5391FE?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI%2BPHBhdGggZmlsbD0iI2ZmZiIgZD0iTTIzLjIgM2MwLjYgMCAwLjkwLjUwLjggMWwtMy43IDE2Yy0wLjEwLjYgLTAuNyAxIC0xLjMgMUgwLjhjLTAuNiAwIC0wLjkgLTAuNSAtMC44IC0xTDMuNyA0YzAuMSAtMC42MC43IC0xIDEuMyAtMXptLTguNCA5LjNjMC4zIC0wLjQwLjIgLTAuOSAtMC4xIC0xLjJMOS4xIDUuMWMtMC40IC0wLjQgLTEgLTAuNCAtMS41MGMtMC40MC40IC0wLjUgMS4xIC0wLjEgMS41bDQuNyA1djAuMWwtNy40IDUuNGMtMC40MC4zIC0wLjUxIC0wLjIgMS41czEwLjYgMS40MC4zbDguMiAtNS45YzAuMyAtMC4yMC40IC0wLjQwLjUgLTAuNXptLTIuOCA0LjRhMC45MC45IDAgMCAwIC0wLjkwLjljMCAwLjUwLjQwLjkwLjkwLjloNC40YTAuOTAuOSAwIDAgMCAwLjkgLTAuOWEwLjkwLjkgMCAwIDAgLTAuOSAtMC45eiIvPjwvc3ZnPg%3D%3D)
![License](https://img.shields.io/badge/License-MIT-green)

![Diagrama: tráfico SSH de Internet llega a Cowrie en EC2, los logs pasan a S3 y activan Lambda, con alertas SNS, CloudWatch y administración por SSM, todo desplegado con Terraform](docs/portada.png)

Infraestructura reproducible en AWS para un honeypot con Cowrie, logs en S3, analisis con Lambda, alertas por SNS y alarmas CloudWatch. Este README unifica toda la documentacion del proyecto.

## 1) Objetivo y alcance
- Levantar un honeypot SSH (Cowrie) en EC2.
- Guardar evidencias en S3.
- Analizar logs con Lambda y enviar alertas por SNS.
- Monitorizar el estado basico de la instancia con CloudWatch.
- Entregar IaC reproducible con Terraform y scripts en PowerShell.

## 2) Arquitectura
```mermaid
flowchart LR
  Internet((Internet)) -->|SSH 22| EC2[EC2 Cowrie]
  EC2 -->|logs| S3[(S3 Logs)]
  S3 -->|ObjectCreated: cowrie/| Lambda[Lambda Analyzer]
  Lambda -->|alerts| SNS[SNS Email]
  Lambda --> CWLogs[CloudWatch Logs]
  EC2 --> CW[CloudWatch Metrics]
  CW -->|alarms| SNS
```

## 3) Decisiones tecnicas
- SSH 22 expuesto para el honeypot.
- Telnet deshabilitado por simplicidad.
- Admin real por SSM (`enable_ssm=true`); si se desactiva, SSH en 22222 con CIDR restringido.
- IP publica estable via EIP.
- Logs sincronizados a S3 cada 5 minutos via cron.
- Bucket S3 con cifrado SSE-S3 y bloqueo de acceso publico.
- `force_destroy=true` en bucket para laboratorios.

## 4) Workflow de equipo
- Rama por persona (ej: `feature/alonso-hito1`).
- PR obligatorio hacia `main`, revisado por otro miembro.
- Sufijo unico por persona: `amm`, `nlr`, `mpg`, `dtm`.
- Prefijo de recursos: `proy-damn-teamssn`.
- Tags: `Project=DAMN-TEAMSSN`, `Owner=<suffix>`, `Env=dev`.

## 5) Estructura del repo
- `infra/`: Terraform raiz y modulos.
- `src/lambda/analyzer/`: codigo Lambda.
- `scripts/`: automatizacion PowerShell.
- `envs/`: tfvars y plantillas.
- `docs/`: documentacion adicional.

## 6) Requisitos
- Terraform >= 1.5
- AWS CLI
- PowerShell (Windows)
- Cuenta AWS laboratorio (region us-east-1)

## 7) Credenciales AWS (no se versionan)
Plantilla: `envs/aws_credentials.example`.

Ubicaciones:
- Windows: `C:\Users\<user>\.aws\credentials`
- Linux/Mac: `~/.aws/credentials`

Crear perfil:
```
aws configure --profile <nombre>
aws sts get-caller-identity --profile <nombre>
```
Si no quieres escribir `--profile` en cada comando:
```
$env:AWS_PROFILE="<nombre>"
```

## 8) Configuracion por persona (tfvars)
1) Copia un ejemplo:
```
Copy-Item .\envs\alonso.tfvars.example .\envs\alonso.tfvars
```
2) Edita `envs/alonso.tfvars`:
- `resource_suffix` (unico).
- `admin_email` (SNS).
- `aws_profile`, `aws_region`.
- `allowed_admin_cidr` (solo si desactivas SSM).
- `existing_instance_profile_name` / `existing_lambda_role_arn` si no tienes permisos IAM.

## 9) Despliegue y destruccion
```
.\scripts\up.ps1 -Env alonso
```
```
.\scripts\down.ps1 -Env alonso
```

## 10) Outputs
```
.\scripts\show_outputs.ps1 -Env alonso
```
Guarda `public_ip`, `instance_id`, `s3_bucket`, `sns_topic_arn`, `lambda_name`.
Nota: `public_ip` se mantiene por la EIP, pero `instance_id` cambia si reemplazas el EC2.

## 11) Verificacion tecnica (Cowrie y SSM)
```
aws ssm describe-instance-information --filters Key=InstanceIds,Values=<instance_id> --profile <aws_profile>
```
```
aws ssm send-command --instance-ids <instance_id> --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_check_ascii.json --profile <aws_profile>
```
Salida esperada:
- `systemctl is-active cowrie` = `active`
- `twistd` escuchando en `:22`

## 12) Prueba final (pipeline completo)
1) Confirma la suscripcion SNS en el email del `admin_email`.
2) Intento SSH controlado:
```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=5 -p 22 fakeuser@<public_ip>
```
3) Forzar sync a S3:
```
aws ssm send-command --instance-ids <instance_id> --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile <aws_profile>
```
4) Ver objetos en S3:
```
aws s3 ls s3://<s3_bucket>/cowrie/<suffix>/
```
5) Ver logs de Lambda:
```
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --since 10m --profile <aws_profile>
```
6) Verificar emails:
- Alerta SNS del honeypot.
- OK/ALARM de CloudWatch (si cambia el estado).

Si no llega alerta, sube eventos hasta superar umbrales y vuelve a sincronizar:
```
1..10 | ForEach-Object { ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=3 -p 22 fakeuser@<public_ip> }
aws ssm send-command --instance-ids <instance_id> --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile <aws_profile>
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --since 10m --profile <aws_profile>
```

## 13) Runbook rapido (comandos en orden)
Parametrizado:
```
scripts\up.ps1 -Env <env>
scripts\show_outputs.ps1 -Env <env>
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=5 -p 22 fakeuser@<public_ip>
aws ssm send-command --instance-ids <instance_id> --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile <aws_profile>
aws s3 ls s3://<s3_bucket>/cowrie/<suffix>/
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --since 10m --profile <aws_profile>
scripts\down.ps1 -Env <env>
```
Ejemplo real:
```
scripts\up.ps1 -Env alonso
scripts\show_outputs.ps1 -Env alonso
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o BatchMode=yes -o ConnectTimeout=5 -p 22 fakeuser@54.236.128.229
aws ssm send-command --instance-ids i-04b9ab0c57e0a2446 --document-name "AWS-RunShellScript" --parameters file://scripts/ssm_cowrie_sync.json --profile alonso
aws s3 ls s3://proy-damn-teamssn-logs-amm2-851725275441/cowrie/amm2/
aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-amm2 --since 10m --profile alonso
scripts\down.ps1 -Env alonso
```

## 14) Reemplazar solo el EC2 (user_data nuevo)
```
terraform -chdir=infra apply -var-file=.\envs\alonso.tfvars -replace=module.honeypot_ec2.aws_instance.honeypot -auto-approve
```

## 15) Troubleshooting rapido
- BucketAlreadyExists:
  - Cambia `resource_suffix`.
- SNS no llega:
  - Revisa `PendingConfirmation` con `aws sns list-subscriptions-by-topic`.
  - Acepta el email.
- Lambda sin log group:
  - No se ha invocado; sube logs a S3 primero.
- SSH "connection refused":
  - Cowrie no esta activo; revisa con SSM.
- Error Python incompatible:
  - Cowrie requiere Python 3.11 en Amazon Linux 2023.
- Duplicado `listen_endpoints`:
  - Revisar `cowrie.cfg` si hubo cambios manuales.

## 16) Scripts utiles
- `scripts\up.ps1` / `scripts\down.ps1`
- `scripts\show_outputs.ps1`
- `scripts\ssm_cowrie_check_ascii.json`
- `scripts\ssm_cowrie_sync.json`
