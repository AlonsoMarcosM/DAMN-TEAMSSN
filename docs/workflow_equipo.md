# Workflow equipo

## Ramas y PRs
- Cada persona trabaja en su propia rama (ej: feature/alonso-hito1).
- Pull Request obligatorio hacia main, con revision por al menos otro miembro.
- Coordinacion y seguimiento desde Microsoft Teams con panel de GitHub.

## Convenciones de naming
- Sufijo unico por persona en recursos: amm, nlr, mpg, dtm.
- Prefijo de proyecto: proy-damn-teamssn.
- Tags obligatorios en todos los recursos: Project=DAMN-TEAMSSN, Owner=<suffix>, Env=dev.

## IaC y cambios rapidos
- Terraform modular en infra/.
- Scripts PowerShell en scripts/ para apply/destroy y despliegue rapido de Lambda.
- No se comparten credenciales ni tfvars reales en el repo.
