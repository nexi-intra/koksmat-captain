
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot .. ..)) 

write-host "Root: $root"

. "$root/.koksmat/pwsh/check-env.ps1" "APP_APPLICATION_CERTIFICATE", "APP_APPLICATION_ID", "APP_APPLICATION_DOMAIN"
. "$root/.koksmat/pwsh/connectors/application/connect.ps1"

