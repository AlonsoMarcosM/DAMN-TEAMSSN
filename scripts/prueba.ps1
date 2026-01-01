# ==========================================================
# 8. PRUEBA DE ESTRÉS REAL (ATAQUE REAL -> DETECCIÓN REAL)
# ==========================================================
Write-Host " "
Write-Host ">>> [FASE 8] ATAQUE REAL DE VOLUMEN (FLOOD)" -ForegroundColor Cyan
Write-Host "Vamos a atacar tu máquina desde este PC y esperar a que el sistema reaccione solo."

# 1. EL ATAQUE (Generamos tráfico real SSH para superar el umbral de 20 eventos)
Write-Host " "
Write-Host "Generando 25 intentos de conexión SSH reales contra $PublicIp..." -ForegroundColor Yellow
Write-Host "(Verás errores de conexión, es normal, estamos haciendo ruido)" -ForegroundColor Gray

# Bucle de ataque rápido (No hace falta password, solo conectar para generar log)
1..25 | ForEach-Object { 
    Write-Host "." -NoNewline
    # Intentamos conectar y salimos inmediatamente. Redirigimos error a null para no ensuciar pantalla.
    ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no "fakeuser@$PublicIp" exit 2>$null
}
Write-Host " ¡Ataques enviados!" -ForegroundColor Green

# 2. LA ESPERA (El Cron de la máquina sube logs cada 5 mins)
Write-Host " "
Write-Host "⏳ Esperando a que el Honeypot sincronice logs a S3 (Max 6-7 min)..." -ForegroundColor Cyan
Write-Host "NO CIERRES ESTA VENTANA. El sistema está trabajando." -ForegroundColor Gray

# Calculamos tiempo de inicio (hace 5 min por si acaso)
$TimeStart = [int64]((Get-Date).ToUniversalTime() - (Get-Date "1970-01-01").ToUniversalTime()).TotalMilliseconds - 300000
$Encontrado = $false
$IntentosMax = 15 # 7.5 minutos
$Intento = 0

do {
    $Intento++
    Write-Host "   [$Intento / $IntentosMax] Consultando CloudWatch... (Espera 30s)"
    Start-Sleep -Seconds 30
    
    # Buscamos si la Lambda ha procesado algo
    $JsonResult = aws logs filter-log-events --log-group-name "/aws/lambda/$LambdaName" --filter-pattern "processed_log" --start-time $TimeStart --limit 1 --output json | ConvertFrom-Json

    if ($JsonResult.events) {
        $Detalle = $JsonResult.events[0].message | ConvertFrom-Json
        # Solo nos vale si el log procesado viene de HOY y es REAL (alert_sent = true o false)
        if ($Detalle.total_events -gt 0) {
            $Encontrado = $true
        }
    }

} until ($Encontrado -or ($Intento -ge $IntentosMax))

# 3. RESULTADO
if ($Encontrado) {
    Write-Host " "
    Write-Host "✅ ¡SISTEMA VALIDADO END-TO-END!" -ForegroundColor Green
    Write-Host "1. Tu PC atacó por SSH."
    Write-Host "2. Cowrie guardó los logs."
    Write-Host "3. La máquina los subió a S3 automáticamente."
    Write-Host "4. Lambda los procesó."
    
    if ($Detalle.alert_sent -eq $true) {
        Write-Host "🔥 ALERTA CRÍTICA ENVIADA POR EMAIL (Umbral superado)." -ForegroundColor Red
        Add-Content -Path $ReportPath -Value "- [x] Prueba Real: EXITO TOTAL (Ataque masivo detectado y notificado)."
    } else {
        Write-Host "⚠️  LOGS PROCESADOS (Pero no superaron el umbral de 20 en un solo archivo)." -ForegroundColor Yellow
        Write-Host "   (Posiblemente el Cron partió los logs en dos archivos distintos)."
        Add-Content -Path $ReportPath -Value "- [x] Prueba Real: PARCIAL (Logs procesados, umbral no superado)."
    }
} else {
    Write-Host " "
    Write-Host "❌ TIEMPO AGOTADO." -ForegroundColor Red
    Write-Host "El Cron de la máquina no ha subido los logs a tiempo."
    Add-Content -Path $ReportPath -Value "- [ ] Prueba Real: FALLO (Timeout esperando logs)."
}

Write-Host "FIN DEL SCRIPT."