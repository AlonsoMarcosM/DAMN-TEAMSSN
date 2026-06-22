# Publicación documental segura

GitHub Pages presenta la arquitectura, los módulos Terraform y el runbook sin exponer un honeypot real ni generar coste o superficie de ataque permanente.

El workflow `.github/workflows/pages.yml` construye el repositorio con Jekyll y publica `https://alonsomarcosm.github.io/DAMN-TEAMSSN/`.

La infraestructura AWS solo debe levantarse temporalmente en un entorno controlado y destruirse al terminar las pruebas.

Última verificación de configuración: 2026-06-22.
