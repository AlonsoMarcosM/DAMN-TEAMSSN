param(
  [string]$SourceDir = "$PSScriptRoot\..\src\lambda\analyzer",
  [string]$OutputPath = "$PSScriptRoot\..\build\lambda_analyzer.zip"
)

$repoRoot = Resolve-Path "$PSScriptRoot\.."
$source = Resolve-Path $SourceDir
$buildDir = Split-Path $OutputPath -Parent

if (-not (Test-Path $buildDir)) {
  New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
}

if (Test-Path $OutputPath) {
  Remove-Item $OutputPath -Force
}

Compress-Archive -Path (Join-Path $source "*") -DestinationPath $OutputPath
Write-Host "Created $OutputPath"
