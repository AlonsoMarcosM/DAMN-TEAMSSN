# AGENTS.md

## Objetivo

Mantener el honeypot reproducible como infraestructura bajo demanda y publicarlo solo como evidencia documental segura.

## Reglas

- No mantener el honeypot, EC2, EIP, S3, Lambda o SNS activos para el portfolio.
- Nunca publicar credenciales AWS, correos SNS, IP administrativas ni ficheros `tfvars` reales.
- No duplicar el README; `index.md` lo reutiliza como fuente canónica.
- Mantener coherentes `docs/portfolio_deployment.md` y `portfolio.json`.

## Verificación mínima

Ejecutar `terraform fmt -check` y `terraform validate` cuando cambie IaC; para la publicación, comprobar el workflow `pages.yml`.
