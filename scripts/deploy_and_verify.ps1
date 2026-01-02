# Definir rutas
$RepoRoot = Resolve-Path "$PSScriptRoot\.."
$EnvsPath = Join-Path $RepoRoot "envs"
$InfraPath = Join-Path $RepoRoot "infra"

# Verificar credenciales de AWS
Write-Host "Verificando conexión con AWS..." -ForegroundColor Cyan
aws sts get-caller-identity > $null 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Iniciando configuración de credenciales..." -ForegroundColor Yellow
    aws configure
    aws sts get-caller-identity > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error: Las credenciales siguen fallando." -ForegroundColor Red
        exit 1
    }
}
Write-Host "AWS Conectado." -ForegroundColor Green

# Datos del usuario
$Suffix = Read-Host "Escribe el sufijo con el que se crearán los archivos (por ejemplo, las iniciales de tu nombre)"
if ($Suffix -eq "") { Write-Error "El sufijo es obligatorio"; exit 1 }

$Email = Read-Host "Escribe el email al que quieres que lleguen los correos de aviso"
if ($Email -eq "") { Write-Error "El email es obligatorio"; exit 1 }

$Account = aws sts get-caller-identity --query "Account" --output text
$ProfileName = "LabInstanceProfile"
$RoleArn = "arn:aws:iam::" + $Account + ":role/LabRole"

# Generar archivo de configuración
$RutaArchivo = Join-Path $EnvsPath "$Suffix.auto.tfvars"

# Borramos archivo viejo
if (Test-Path $RutaArchivo) { Remove-Item $RutaArchivo -Force }

Add-Content -Path $RutaArchivo -Value ('resource_suffix = "' + $Suffix + '"')
Add-Content -Path $RutaArchivo -Value ('admin_email = "' + $Email + '"')
Add-Content -Path $RutaArchivo -Value 'aws_region = "us-east-1"'
Add-Content -Path $RutaArchivo -Value 'ami_id = ""'
Add-Content -Path $RutaArchivo -Value 'enable_ssm = true'
Add-Content -Path $RutaArchivo -Value ('existing_instance_profile_name = "' + $ProfileName + '"')
Add-Content -Path $RutaArchivo -Value ('existing_lambda_role_arn = "' + $RoleArn + '"')
Add-Content -Path $RutaArchivo -Value ('allowed_admin_cidr = "84.121.114.164/32"')

Write-Host "Archivo de variables generado: $RutaArchivo" -ForegroundColor Green

# Terraform
Write-Host "Iniciando Terraform..." -ForegroundColor Cyan

$ArgChdir   = "-chdir=$InfraPath"
$ArgVarFile = "-var-file=$RutaArchivo"

& terraform $ArgChdir init -input=false

& terraform $ArgChdir apply $ArgVarFile -auto-approve

if ($LASTEXITCODE -ne 0) {
    Write-Error "Falloo en el despliegue."
    exit 1
}

# Pausa para aceptar suscripción
Read-Host "Pronto llegará un correo de confirmación para la suscripción de los avisos. Presiona ENTER una vez la suscripción esté confirmada para continuar con las pruebas." -ForegroundColor Yellow

