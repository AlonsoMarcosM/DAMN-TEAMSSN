# DAMN-TEAMSSN - Honeypot en AWS (documentacion completa)

> **Despliegue público:** [Abrir despliegue](https://alonsomarcosm.github.io/DAMN-TEAMSSN/)

![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A5%201.5-844FBA?logo=terraform&logoColor=white)
![AWS provider](https://img.shields.io/badge/AWS%20provider-~%3E%205.0-FF9900?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI%2BPHBhdGggZmlsbD0iI2ZmZmZmZiIgZD0iTTYuNzYzIDEwLjAzNnEuMDAyLjQ0Ni4wODguNzFjLjA2NC4xNzYuMTQ0LjM2OC4yNTYuNTc2Yy4wNC4wNjMuMDU2LjEyNy4wNTYuMTgzcS4wMDIuMTItLjE1Mi4yNGwtLjUwMy4zMzVhLjQuNCAwIDAgMS0uMjA4LjA3MnEtLjEyLS4wMDItLjIzOS0uMTEyYTIuNSAyLjUgMCAwIDEtLjI4Ny0uMzc1YTYgNiAwIDAgMS0uMjQ4LS40NzFxLS45MzQgMS4xMDEtMi4zNDcgMS4xMDFjLS42NyAwLTEuMjA1LS4xOTEtMS41OTYtLjU3NHEtLjU4OC0uNTc1LS41OS0xLjUzM2MwLS42NzguMjM5LTEuMjMuNzI2LTEuNjQ0Yy40ODctLjQxNSAxLjEzMy0uNjIzIDEuOTU1LS42MjNjLjI3MiAwIC41NTEuMDI0Ljg0Ni4wNjRjLjI5Ni4wNC42LjEwNC45MTguMTc2di0uNTgzcS0uMDAxLS45MDktLjM3NS0xLjI3N2MtLjI1NS0uMjQ4LS42ODYtLjM2Ny0xLjMtLjM2N2MtLjI4IDAtLjU2OC4wMzEtLjg2My4xMDNxLS40NDMuMTA2LS44NjIuMjcyYTIgMiAwIDAgMS0uMjguMTA0YS41LjUgMCAwIDEtLjEyNy4wMjNxLS4xNjguMDAyLS4xNjgtLjI0N3YtLjM5MWMwLS4xMjguMDE2LS4yMjQuMDU2LS4yOGEuNi42IDAgMCAxIC4yMjQtLjE2N2E0LjYgNC42IDAgMCAxIDEuMDA1LS4zNmE0LjggNC44IDAgMCAxIDEuMjQ2LS4xNTFjLjk1IDAgMS42NDQuMjE2IDIuMDkxLjY0N3EuNjYuNjQ1LjY2MiAxLjk2M3YyLjU4NnptLTMuMjQgMS4yMTRjLjI2MyAwIC41MzQtLjA0OC44MjItLjE0NGExLjggMS44IDAgMCAwIC43NTgtLjUxYTEuMyAxLjMgMCAwIDAgLjI3Mi0uNTEyYy4wNDctLjE5MS4wOC0uNDIzLjA4LS42OTR2LS4zMzVhNyA3IDAgMCAwLS43MzUtLjEzNmE2IDYgMCAwIDAtLjc1LS4wNDhjLS41MzUgMC0uOTI2LjEwNC0xLjE5LjMyYy0uMjYzLjIxNS0uMzkuNTE4LS4zOS45MTdjMCAuMzc1LjA5NS42NTUuMjk1Ljg0NmMuMTkxLjIuNDcuMjk2LjgzOC4yOTZtNi40MS44NjJjLS4xNDQgMC0uMjQtLjAyNC0uMzA0LS4wOGMtLjA2NC0uMDQ4LS4xMi0uMTYtLjE2OC0uMzExTDcuNTg2IDUuNTVhMS40IDEuNCAwIDAgMS0uMDcyLS4zMmMwLS4xMjguMDY0LS4yLjE5MS0uMmguNzgzcS4yMjctLjAwMS4zMS4wOGMuMDY1LjA0OC4xMTMuMTYuMTYuMzEybDEuMzQyIDUuMjg0bDEuMjQ1LTUuMjg0cS4wNTgtLjI0LjE1MS0uMzEyYS41NS41NSAwIDAgMSAuMzItLjA4aC42MzhjLjE1MiAwIC4yNTYuMDI1LjMyLjA4Yy4wNjMuMDQ4LjEyLjE2LjE1MS4zMTJsMS4yNjEgNS4zNDhsMS4zODEtNS4zNDhxLjA3NC0uMjQuMTYtLjMxMmEuNTIuNTIgMCAwIDEgLjMxMS0uMDhoLjc0M2MuMTI3IDAgLjIuMDY1LjIuMmMwIC4wNC0uMDA5LjA4LS4wMTcuMTI4YTEgMSAwIDAgMS0uMDU2LjJsLTEuOTIzIDYuMTdxLS4wNzIuMjQtLjE2OC4zMTFhLjUuNSAwIDAgMS0uMzAzLjA4aC0uNjg3Yy0uMTUxIDAtLjI1NS0uMDI0LS4zMi0uMDhjLS4wNjMtLjA1Ni0uMTE5LS4xNi0uMTUtLjMybC0xLjIzOC01LjE0OGwtMS4yMyA1LjE0Yy0uMDQuMTYtLjA4Ny4yNjQtLjE1LjMyYy0uMDY1LjA1Ni0uMTc3LjA4LS4zMi4wOHptMTAuMjU2LjIxNWMtLjQxNSAwLS44My0uMDQ4LTEuMjI5LS4xNDNjLS4zOTktLjA5Ni0uNzEtLjItLjkxOC0uMzJjLS4xMjgtLjA3MS0uMjE1LS4xNTEtLjI0Ny0uMjIzYS42LjYgMCAwIDEtLjA0OC0uMjI0di0uNDA3YzAtLjE2Ny4wNjQtLjI0Ny4xODMtLjI0N3EuMDcyIDAgLjE0NC4wMjRjLjA0OC4wMTYuMTIuMDQ4LjIuMDhxLjQwOC4xODEuODc4LjI3OWMuMzE5LjA2NC42My4wOTYuOTUuMDk2Yy41MDIgMCAuODk0LS4wODggMS4xNjUtLjI2NGEuODYuODYgMCAwIDAgLjQxNS0uNzU4YS43OC43OCAwIDAgMC0uMjE1LS41NTljLS4xNDQtLjE1MS0uNDE2LS4yODctLjgwNy0uNDE1bC0xLjE1Ny0uMzZjLS41ODMtLjE4My0xLjAxNC0uNDU0LTEuMjc3LS44MTNhMS45IDEuOSAwIDAgMS0uNC0xLjE1OHEwLS41MDIuMjE2LS44ODZjLjE0NC0uMjU1LjMzNS0uNDc5LjU3NS0uNjU0Yy4yNC0uMTg0LjUxLS4zMi44My0uNDE1Yy4zMi0uMDk2LjY1NS0uMTM2IDEuMDA2LS4xMzZjLjE3NSAwIC4zNTkuMDA4LjUzNS4wMzJjLjE4My4wMjQuMzUuMDU2LjUxOC4wODhxLjI0LjA1OC40NTUuMTI3cS4yMTYuMDcyLjMzNi4xNDRhLjcuNyAwIDAgMSAuMjQuMmEuNDMuNDMgMCAwIDEgLjA3MS4yNjN2LjM3NXEtLjAwMi4yNTQtLjE4NC4yNTZhLjguOCAwIDAgMS0uMzAzLS4wOTZhMy42NSAzLjY1IDAgMCAwLTEuNTMyLS4zMTFjLS40NTUgMC0uODE1LjA3MS0xLjA2Mi4yMjNzLS4zNzUuMzgzLS4zNzUuNzFjMCAuMjI0LjA4LjQxNi4yNC41NjdjLjE1OS4xNTIuNDU0LjMwNC44NzcuNDRsMS4xMzQuMzU4Yy41NzQuMTg0Ljk5LjQ0IDEuMjM3Ljc2N3MuMzY3LjcwMi4zNjcgMS4xMTdjMCAuMzQzLS4wNzIuNjU1LS4yMDcuOTI2YTIuMiAyLjIgMCAwIDEtLjU4My43MDNjLS4yNDguMi0uNTQzLjM0My0uODg2LjQ0N2MtLjM2LjExMS0uNzM0LjE2Ny0xLjE0Mi4xNjdtMS41MDkgMy44OGMtMi42MjYgMS45NC02LjQ0MiAyLjk2OS05LjcyMiAyLjk2OWMtNC41OTggMC04Ljc0LTEuNy0xMS44Ny00LjUyNmMtLjI0Ny0uMjIzLS4wMjQtLjUyNy4yNzItLjM1MWMzLjM4NCAxLjk2MyA3LjU1OSAzLjE1MyAxMS44NzcgMy4xNTNjMi45MTQgMCA2LjExNC0uNjA3IDkuMDYtMS44NTJjLjQzOS0uMi44MTQuMjg3LjM4My42MDdtMS4wOTQtMS4yNDZjLS4zMzYtLjQzLTIuMjItLjIwNy0zLjA3NC0uMTAzYy0uMjU1LjAzMi0uMjk1LS4xOTItLjA2My0uMzZjMS41LTEuMDUzIDMuOTY3LS43NSA0LjI1NC0uMzk5Yy4yODcuMzYtLjA4IDIuODI2LTEuNDg1IDQuMDA3Yy0uMjE1LjE4NC0uNDIzLjA4OC0uMzI3LS4xNTFjLjMyLS43OSAxLjAzLTIuNTcuNjk1LTIuOTk0Ii8%2BPC9zdmc%2B)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20S3%20%7C%20Lambda%20%7C%20SNS%20%7C%20CloudWatch%20%7C%20SSM-FF9900?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI%2BPHBhdGggZmlsbD0iI2ZmZmZmZiIgZD0iTTYuNzYzIDEwLjAzNnEuMDAyLjQ0Ni4wODguNzFjLjA2NC4xNzYuMTQ0LjM2OC4yNTYuNTc2Yy4wNC4wNjMuMDU2LjEyNy4wNTYuMTgzcS4wMDIuMTItLjE1Mi4yNGwtLjUwMy4zMzVhLjQuNCAwIDAgMS0uMjA4LjA3MnEtLjEyLS4wMDItLjIzOS0uMTEyYTIuNSAyLjUgMCAwIDEtLjI4Ny0uMzc1YTYgNiAwIDAgMS0uMjQ4LS40NzFxLS45MzQgMS4xMDEtMi4zNDcgMS4xMDFjLS42NyAwLTEuMjA1LS4xOTEtMS41OTYtLjU3NHEtLjU4OC0uNTc1LS41OS0xLjUzM2MwLS42NzguMjM5LTEuMjMuNzI2LTEuNjQ0Yy40ODctLjQxNSAxLjEzMy0uNjIzIDEuOTU1LS42MjNjLjI3MiAwIC41NTEuMDI0Ljg0Ni4wNjRjLjI5Ni4wNC42LjEwNC45MTguMTc2di0uNTgzcS0uMDAxLS45MDktLjM3NS0xLjI3N2MtLjI1NS0uMjQ4LS42ODYtLjM2Ny0xLjMtLjM2N2MtLjI4IDAtLjU2OC4wMzEtLjg2My4xMDNxLS40NDMuMTA2LS44NjIuMjcyYTIgMiAwIDAgMS0uMjguMTA0YS41LjUgMCAwIDEtLjEyNy4wMjNxLS4xNjguMDAyLS4xNjgtLjI0N3YtLjM5MWMwLS4xMjguMDE2LS4yMjQuMDU2LS4yOGEuNi42IDAgMCAxIC4yMjQtLjE2N2E0LjYgNC42IDAgMCAxIDEuMDA1LS4zNmE0LjggNC44IDAgMCAxIDEuMjQ2LS4xNTFjLjk1IDAgMS42NDQuMjE2IDIuMDkxLjY0N3EuNjYuNjQ1LjY2MiAxLjk2M3YyLjU4NnptLTMuMjQgMS4yMTRjLjI2MyAwIC41MzQtLjA0OC44MjItLjE0NGExLjggMS44IDAgMCAwIC43NTgtLjUxYTEuMyAxLjMgMCAwIDAgLjI3Mi0uNTEyYy4wNDctLjE5MS4wOC0uNDIzLjA4LS42OTR2LS4zMzVhNyA3IDAgMCAwLS43MzUtLjEzNmE2IDYgMCAwIDAtLjc1LS4wNDhjLS41MzUgMC0uOTI2LjEwNC0xLjE5LjMyYy0uMjYzLjIxNS0uMzkuNTE4LS4zOS45MTdjMCAuMzc1LjA5NS42NTUuMjk1Ljg0NmMuMTkxLjIuNDcuMjk2LjgzOC4yOTZtNi40MS44NjJjLS4xNDQgMC0uMjQtLjAyNC0uMzA0LS4wOGMtLjA2NC0uMDQ4LS4xMi0uMTYtLjE2OC0uMzExTDcuNTg2IDUuNTVhMS40IDEuNCAwIDAgMS0uMDcyLS4zMmMwLS4xMjguMDY0LS4yLjE5MS0uMmguNzgzcS4yMjctLjAwMS4zMS4wOGMuMDY1LjA0OC4xMTMuMTYuMTYuMzEybDEuMzQyIDUuMjg0bDEuMjQ1LTUuMjg0cS4wNTgtLjI0LjE1MS0uMzEyYS41NS41NSAwIDAgMSAuMzItLjA4aC42MzhjLjE1MiAwIC4yNTYuMDI1LjMyLjA4Yy4wNjMuMDQ4LjEyLjE2LjE1MS4zMTJsMS4yNjEgNS4zNDhsMS4zODEtNS4zNDhxLjA3NC0uMjQuMTYtLjMxMmEuNTIuNTIgMCAwIDEgLjMxMS0uMDhoLjc0M2MuMTI3IDAgLjIuMDY1LjIuMmMwIC4wNC0uMDA5LjA4LS4wMTcuMTI4YTEgMSAwIDAgMS0uMDU2LjJsLTEuOTIzIDYuMTdxLS4wNzIuMjQtLjE2OC4zMTFhLjUuNSAwIDAgMS0uMzAzLjA4aC0uNjg3Yy0uMTUxIDAtLjI1NS0uMDI0LS4zMi0uMDhjLS4wNjMtLjA1Ni0uMTE5LS4xNi0uMTUtLjMybC0xLjIzOC01LjE0OGwtMS4yMyA1LjE0Yy0uMDQuMTYtLjA4Ny4yNjQtLjE1LjMyYy0uMDY1LjA1Ni0uMTc3LjA4LS4zMi4wOHptMTAuMjU2LjIxNWMtLjQxNSAwLS44My0uMDQ4LTEuMjI5LS4xNDNjLS4zOTktLjA5Ni0uNzEtLjItLjkxOC0uMzJjLS4xMjgtLjA3MS0uMjE1LS4xNTEtLjI0Ny0uMjIzYS42LjYgMCAwIDEtLjA0OC0uMjI0di0uNDA3YzAtLjE2Ny4wNjQtLjI0Ny4xODMtLjI0N3EuMDcyIDAgLjE0NC4wMjRjLjA0OC4wMTYuMTIuMDQ4LjIuMDhxLjQwOC4xODEuODc4LjI3OWMuMzE5LjA2NC42My4wOTYuOTUuMDk2Yy41MDIgMCAuODk0LS4wODggMS4xNjUtLjI2NGEuODYuODYgMCAwIDAgLjQxNS0uNzU4YS43OC43OCAwIDAgMC0uMjE1LS41NTljLS4xNDQtLjE1MS0uNDE2LS4yODctLjgwNy0uNDE1bC0xLjE1Ny0uMzZjLS41ODMtLjE4My0xLjAxNC0uNDU0LTEuMjc3LS44MTNhMS45IDEuOSAwIDAgMS0uNC0xLjE1OHEwLS41MDIuMjE2LS44ODZjLjE0NC0uMjU1LjMzNS0uNDc5LjU3NS0uNjU0Yy4yNC0uMTg0LjUxLS4zMi44My0uNDE1Yy4zMi0uMDk2LjY1NS0uMTM2IDEuMDA2LS4xMzZjLjE3NSAwIC4zNTkuMDA4LjUzNS4wMzJjLjE4My4wMjQuMzUuMDU2LjUxOC4wODhxLjI0LjA1OC40NTUuMTI3cS4yMTYuMDcyLjMzNi4xNDRhLjcuNyAwIDAgMSAuMjQuMmEuNDMuNDMgMCAwIDEgLjA3MS4yNjN2LjM3NXEtLjAwMi4yNTQtLjE4NC4yNTZhLjguOCAwIDAgMS0uMzAzLS4wOTZhMy42NSAzLjY1IDAgMCAwLTEuNTMyLS4zMTFjLS40NTUgMC0uODE1LjA3MS0xLjA2Mi4yMjNzLS4zNzUuMzgzLS4zNzUuNzFjMCAuMjI0LjA4LjQxNi4yNC41NjdjLjE1OS4xNTIuNDU0LjMwNC44NzcuNDRsMS4xMzQuMzU4Yy41NzQuMTg0Ljk5LjQ0IDEuMjM3Ljc2N3MuMzY3LjcwMi4zNjcgMS4xMTdjMCAuMzQzLS4wNzIuNjU1LS4yMDcuOTI2YTIuMiAyLjIgMCAwIDEtLjU4My43MDNjLS4yNDguMi0uNTQzLjM0My0uODg2LjQ0N2MtLjM2LjExMS0uNzM0LjE2Ny0xLjE0Mi4xNjdtMS41MDkgMy44OGMtMi42MjYgMS45NC02LjQ0MiAyLjk2OS05LjcyMiAyLjk2OWMtNC41OTggMC04Ljc0LTEuNy0xMS44Ny00LjUyNmMtLjI0Ny0uMjIzLS4wMjQtLjUyNy4yNzItLjM1MWMzLjM4NCAxLjk2MyA3LjU1OSAzLjE1MyAxMS44NzcgMy4xNTNjMi45MTQgMCA2LjExNC0uNjA3IDkuMDYtMS44NTJjLjQzOS0uMi44MTQuMjg3LjM4My42MDdtMS4wOTQtMS4yNDZjLS4zMzYtLjQzLTIuMjItLjIwNy0zLjA3NC0uMTAzYy0uMjU1LjAzMi0uMjk1LS4xOTItLjA2My0uMzZjMS41LTEuMDUzIDMuOTY3LS43NSA0LjI1NC0uMzk5Yy4yODcuMzYtLjA4IDIuODI2LTEuNDg1IDQuMDA3Yy0uMjE1LjE4NC0uNDIzLjA4OC0uMzI3LS4xNTFjLjMyLS43OSAxLjAzLTIuNTcuNjk1LTIuOTk0Ii8%2BPC9zdmc%2B)
![Cowrie](https://img.shields.io/badge/Cowrie-SSH%20honeypot-2F4F4F)
![Python](https://img.shields.io/badge/Lambda-Python%203.11-3776AB?logo=python&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-up%20%2F%20down-5391FE?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI%2BPHBhdGggZmlsbD0iI2ZmZmZmZiIgZD0iTTIzLjE4MSAyLjk3NGMuNTY4IDAgLjkyMy40NjMuNzkyIDEuMDM1bC0zLjY1OSAxNS45ODJjLS4xMy41NzItLjY5NyAxLjAzNS0xLjI2NSAxLjAzNUguODE5Yy0uNTY4IDAtLjkyMy0uNDYzLS43OTItMS4wMzVMMy42ODYgNC4wMDljLjEzLS41NzIuNjk3LTEuMDM1IDEuMjY1LTEuMDM1em0tOC4zNzUgOS4zNDZjLjI1MS0uMzk0LjIyNy0uOTA1LS4wOS0xLjI0M0w5LjEyMiA1LjEyNWMtLjM4LS40MDQtMS4wMzctLjQwNy0xLjQ2Ni0uMDAzYy0uNDI5LjQwMi0uNDY4IDEuMDU2LS4wODggMS40Nmw0LjY2MiA0Ljk2di4xMWwtNy40MiA1LjM3NGMtLjQ1LjMyNy0uNTMzLjk3Ny0uMTg3IDEuNDUzcy45OTEuNTk3IDEuNDQuMjdsOC4yMjktNS45MWMuMjgtLjE5Ni40MzgtLjM2NS41MTQtLjUyem0tMi43OTYgNC4zOTlhLjkzLjkzIDAgMCAwLS45MzQuOTIzYzAgLjUxLjQxOC45MjMuOTM0LjkyM2g0LjQzM2EuOTMuOTMgMCAwIDAgLjkzNC0uOTIzYS45My45MyAwIDAgMC0uOTM0LS45MjN6Ii8%2BPC9zdmc%2B)
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
