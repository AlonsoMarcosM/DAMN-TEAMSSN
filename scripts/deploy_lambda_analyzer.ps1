param(
  [Parameter(Mandatory = $true)][string]$Env
)

function Get-TfVars {
  param([string]$Path)
  $vars = @{}
  Get-Content $Path | ForEach-Object {
    $line = $_.Trim()
    if ($line -eq "" -or $line.StartsWith("#")) { return }
    if ($line -match '^([A-Za-z0-9_]+)\s*=\s*"(.*)"\s*$') {
      $vars[$matches[1]] = $matches[2]
    } elseif ($line -match '^([A-Za-z0-9_]+)\s*=\s*([^#\s]+)\s*$') {
      $vars[$matches[1]] = $matches[2]
    }
  }
  return $vars
}

$repoRoot = Resolve-Path "$PSScriptRoot\.."
$varFile = Join-Path $repoRoot "envs\$Env.tfvars"

if (-not (Test-Path $varFile)) {
  Write-Error "Missing var file: $varFile"
  exit 1
}

$vars = Get-TfVars -Path $varFile
$suffix = $vars.resource_suffix
if (-not $suffix) {
  Write-Error "resource_suffix not found in $varFile"
  exit 1
}

$zipPath = Join-Path $repoRoot "build\lambda_analyzer.zip"
if (-not (Test-Path $zipPath)) {
  & "$PSScriptRoot\build_lambda_zip.ps1" -SourceDir "$repoRoot\src\lambda\analyzer" -OutputPath $zipPath
}

$functionName = "proy-damn-teamssn-analyzer-$suffix"
$profile = $vars.aws_profile
$region = $vars.aws_region

$awsArgs = @("lambda", "update-function-code", "--function-name", $functionName, "--zip-file", "fileb://$zipPath")
if ($profile) { $awsArgs += @("--profile", $profile) }
if ($region) { $awsArgs += @("--region", $region) }

aws @awsArgs
