param(
  [Parameter(Mandatory = $true)][string]$Env
)

$repoRoot = Resolve-Path "$PSScriptRoot\.."
$varFile = Join-Path $repoRoot "envs\$Env.tfvars"

if (-not (Test-Path $varFile)) {
  Write-Error "Missing var file: $varFile"
  exit 1
}

terraform -chdir="$repoRoot\infra" destroy -var-file="$varFile"
