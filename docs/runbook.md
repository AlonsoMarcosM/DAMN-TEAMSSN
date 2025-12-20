# Runbook

## Despliegue y verificacion rapida
1) Ejecuta `scripts\up.ps1 -Env alonso` (o tu entorno).
2) Confirma la suscripcion SNS en el email indicado.
3) Valida que el EC2 esta activo y tiene IP publica (output `public_ip`).
4) Prueba conexion segura a SSH (solo pruebas controladas): `ssh -p 22 fakeuser@<public_ip>`.

## Logs y evidencias
- S3: `s3://proy-damn-teamssn-logs-<suffix>/cowrie/<suffix>/`.
- Lambda logs: `aws logs tail /aws/lambda/proy-damn-teamssn-analyzer-<suffix> --follow`.
- CloudWatch alarms: revisar alarmas de CPU y status check.

## Troubleshooting
- No hay logs en S3:
  - Revisa que el rol de EC2 tenga permisos S3.
  - Comprueba el cron: `sudo systemctl status crond`.
- Lambda no se dispara:
  - Verifica notificacion S3 y permisos de invocacion.
  - Revisa el prefijo `cowrie/`.
- No llegan emails:
  - Confirma suscripcion SNS en el correo.
  - Revisa el topic ARN en outputs.

## Redeploy Lambda sin Terraform
- Ejecuta `scripts\deploy_lambda_analyzer.ps1 -Env alonso`.

## Apagado
- Ejecuta `scripts\down.ps1 -Env alonso`.
