# Guia completa de uso (paso a paso)

Esta guia explica desde cero como configurar el proyecto, desplegarlo, verificar servicios en AWS, hacer pruebas, modificar las Lambdas, mantener la arquitectura al dia y destruir todo con Terraform.

## 1) Requisitos
- Terraform >= 1.5
- AWS CLI
- PowerShell (Windows)
- Cuenta AWS de laboratorio en us-east-1

## 2) Estructura del repositorio (orientacion rapida)
- `infra/`: Terraform raiz y modulos.
- `src/lambda/analyzer/`: codigo de la Lambda.
- `scripts/`: automatizacion PowerShell (apply/destroy/build/deploy).
- `envs/`: ejemplos de tfvars y plantilla de credenciales.
- `docs/`: documentacion (arquitectura, decisiones, runbook).

## 3) Credenciales de AWS (no se versionan)
Plantilla de ejemplo: `envs/aws_credentials.example`.

Ubicacion de credenciales reales:
- Windows: `C:\Users\<user>\.aws\credentials`
- Linux/Mac: `~/.aws/credentials`

### Opcion A: usar `aws configure` (recomendado)
1) Ejecuta:
```
aws configure --profile <nombre>
```
2) Pega los valores cuando los pida:
   - AWS Access Key ID
   - AWS Secret Access Key
   - AWS Session Token (si es temporal)
   - Default region name (usa `us-east-1`)
3) Verifica acceso:
```
aws sts get-caller-identity --profile <nombre>
```

### Opcion B: pegar credenciales en el archivo
Si tu consola de AWS te da un bloque tipo "AWS CLI: copy/paste in ~/.aws/credentials":
1) Abre el archivo de credenciales:
   - Windows:
```
notepad C:\Users\<user>\.aws\credentials
```
   - Linux/Mac:
```
nano ~/.aws/credentials
```
2) Pega el bloque en el archivo y guarda.
   - Si el bloque esta bajo `[default]`, entonces se usara el perfil por defecto.
3) Verifica acceso:
```
aws sts get-caller-identity --profile <nombre>
```
Si usaste `[default]`, puedes omitir `--profile`.

Tip: si vas a usar un perfil fijo en comandos, puedes exportarlo una vez:
```
$env:AWS_PROFILE = "<nombre>"
```

## 4) Configuracion por persona (tfvars)
1) Copia un ejemplo de tfvars desde la plantilla a un archivo nuevo o editalo y sigue los siguientes pasos:
   - `envs/alonso.tfvars.example` -> `envs/alonso.tfvars`
2) Edita los campos minimos:
   - `resource_suffix`: sufijo unico (amm, nlr, mpg, dtm).
   - `admin_email`: correo para SNS.
   - `allowed_admin_cidr`: tu IP o rango (solo si desactivas SSM).
3) Parametros utiles:
   - `aws_profile`, `aws_region` (por defecto us-east-1).
   - `threshold_total`, `threshold_per_ip` (alertas).
   - `enable_ssm` (recomendado true).
   - `ami_id` (deja "" para usar Amazon Linux 2023 kernel 6.1).
   - `existing_instance_profile_name` (si no tienes permisos IAM).
   - `existing_lambda_role_arn` (si no tienes permisos IAM).

## 5) Despliegue con Terraform (paso a paso con comandos)
1) Abre PowerShell en la raiz del repo.
2) Copia tu tfvars:
```
Copy-Item .\envs\alonso.tfvars.example .\envs\alonso.tfvars
```
3) Edita tu tfvars:
```
notepad .\envs\alonso.tfvars
```
4) Asegura que `resource_suffix` es unico cada vez que despliegas.
   - El bucket S3 es global: si el nombre ya existe, el despliegue falla.
   - Si quieres un despliegue "totalmente diferente", cambia el sufijo (ej: `amm1`, `amm2`).
4) Despliega:
```
.\scripts\up.ps1 -Env alonso
```

Al finalizar, guarda los outputs importantes:
- `public_ip`, `s3_bucket`, `lambda_name`, `sns_topic_arn`, `cowrie_log_prefix`.
Puedes verlos con:
```
.\scripts\show_outputs.ps1 -Env alonso
```

## 6) Verificacion de servicios en AWS (con comandos)
Confirma que todos los componentes estan operativos. Puedes usar consola AWS o CLI.

### EC2 (honeypot)
1) Obtiene el output de Terraform:
```
terraform -chdir=.\infra output
```
2) Comprueba EC2 y EIP:
```
aws ec2 describe-instances --filters "Name=tag:Project,Values=DAMN-TEAMSSN" --query "Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]" --output table
```

### S3 (logs)
1) Lista el bucket:
```
aws s3 ls
```
2) Verifica prefijo de logs:
```
aws s3 ls s3://proy-damn-teamssn-logs-<suffix>/cowrie/<suffix>/
```
Nota: el bucket incluye el `account_id` para evitar colisiones globales:
`proy-damn-teamssn-logs-<suffix>-<account_id>`.

### Lambda (analyzer)
1) Verifica la funcion:
```
aws lambda get-function --function-name proy-damn-teamssn-analyzer-<suffix>
```
2) Comprueba el trigger (S3 notification):
```
aws s3api get-bucket-notification-configuration --bucket proy-damn-teamssn-logs-<suffix>
```

### SNS (alertas)
1) Lista topics:
```
aws sns list-topics
```
2) Confirma suscripciones pendientes en tu email.

### CloudWatch
1) Logs de Lambda:
```
.\scripts\tail_logs_lambda_analyzer.ps1 -Env alonso
```
2) Alarmas activas:
```
aws cloudwatch describe-alarms --query "MetricAlarms[?contains(AlarmName, 'damn')].AlarmName"
```

## 7) Prueba basica (controlada, paso a paso)
Solo desde tu entorno y para validar el pipeline:
1) Intenta un SSH de prueba al honeypot:
```
ssh -p 22 fakeuser@<public_ip>
```
2) Espera a que Cowrie sincronice logs a S3 (cron cada 5 min).
3) Verifica:
   - Nuevo objeto en S3 bajo `cowrie/<suffix>/`.
   - Logs en CloudWatch para la Lambda.
   - Email de alerta si supera umbrales.

## 8) Donde modificar las Lambdas
La Lambda principal es el analizador:
- Codigo: `src/lambda/analyzer/app.py`
- Dependencias: `src/lambda/analyzer/requirements.txt`

Si necesitas cambiar permisos, env vars o trigger:
- Terraform de Lambda: `infra/modules/lambda_analyzer/main.tf`

Si cambias la estructura del pipeline (nuevos servicios o flujos):
- Actualiza arquitectura en `docs/arquitectura.md`.
- Registra decisiones en `docs/decisiones.md` si aplica.

## 9) Como actualizar la Lambda en AWS (comandos)
Opcion rapida (sin Terraform, solo codigo):
```
.\scripts\deploy_lambda_analyzer.ps1 -Env alonso
```

Opcion completa (infra + codigo):
```
.\scripts\up.ps1 -Env alonso
```

Notas:
- `scripts\build_lambda_zip.ps1` genera `build\lambda_analyzer.zip`.
- Terraform empaqueta automaticamente con `archive_file` si haces apply.

## 10) Actualizar el repositorio y la arquitectura
Cuando modifiques comportamiento o flujo:
1) Actualiza codigo de Lambda en `src/lambda/analyzer/`.
2) Ajusta Terraform si hay cambios en permisos, variables o triggers.
3) Refleja cambios en `docs/arquitectura.md` (diagrama mermaid).
4) Documenta decisiones en `docs/decisiones.md`.

## 11) Apagar/destruir todo con Terraform (comando)
Para eliminar recursos del laboratorio:
```
.\scripts\down.ps1 -Env alonso
```

Notas:
- El bucket de logs permite `force_destroy` para borrar objetos en laboratorio.
- Confirma que no necesitas los logs antes de destruir.
- Si quieres volver a desplegar con nombres nuevos, cambia `resource_suffix` y vuelve a ejecutar `up.ps1`.

## 12) Despliegues multiples y reemplazables
Si quieres que cada `up.ps1` sea un despliegue distinto:
1) Crea un nuevo archivo de entorno por despliegue.
```
Copy-Item .\envs\alonso.tfvars.example .\envs\alonso-01.tfvars
notepad .\envs\alonso-01.tfvars
```
2) Cambia `resource_suffix` a un valor unico en cada archivo.
3) Despliega con el nombre del entorno:
```
.\scripts\up.ps1 -Env alonso-01
```
4) Para destruir ese despliegue usa el mismo `-Env`:
```
.\scripts\down.ps1 -Env alonso-01
```

## 13) Comandos rapidos
```
.\scripts\up.ps1 -Env alonso
.\scripts\show_outputs.ps1 -Env alonso
.\scripts\tail_logs_lambda_analyzer.ps1 -Env alonso
.\scripts\down.ps1 -Env alonso
```

## 14) Re-deploy sin cambios (solo verificacion)
Si solo quieres revisar el estado sin modificar nada:
```
terraform -chdir=.\infra plan -var-file=.\envs\alonso.tfvars
terraform -chdir=.\infra output
```

## 15) Troubleshooting rapido
- No llegan emails: confirma la suscripcion SNS.
- No hay logs en S3: revisa permisos del rol EC2 y el cron de sync.
- Lambda no se dispara: valida notificacion S3 y prefijo `cowrie/`.
- Error `iam:CreateRole` en Terraform:
  - En laboratorios tipo VocLabs es comun no tener permisos IAM.
  - Solucion A: solicita permisos IAM al instructor.
  - Solucion B: usa roles existentes del laboratorio:
    - `existing_instance_profile_name`: nombre del instance profile ya creado.
    - `existing_lambda_role_arn`: ARN del rol para Lambda.
    - Estos roles deben tener permisos S3, SNS y CloudWatch Logs.
- Credenciales temporales expiran:
  - Vuelve a ejecutar `aws configure --profile <nombre>` y repite `aws sts get-caller-identity`.
- Error `BucketAlreadyExists` en S3:
  - El bucket es global; cambia `resource_suffix` en tu tfvars y reintenta.
