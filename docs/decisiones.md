# Decisiones tecnicas

## Puertos expuestos
- Se expone SSH en 22 para el honeypot (Cowrie).
- Telnet no se habilita en esta version minima para reducir superficie y complejidad.
- Admin real por SSM (enable_ssm=true). Si se desactiva, se usa SSH en puerto 22222 y CIDR restringido.

## Acceso administrador
- Se prioriza SSM para evitar exponer SSH real en 22.
- sshd se deshabilita cuando SSM esta activo.

## IP publica estable
- Se asigna EIP al EC2 para mantener IP publica estable durante el laboratorio.

## Logs
- Cowrie escribe logs locales y se sincronizan a S3 cada 5 minutos via cron.
- S3 tiene bloqueo de acceso publico y cifrado SSE-S3.
- El bucket de logs usa `force_destroy=true` para permitir `terraform destroy` en entornos de laboratorio.
