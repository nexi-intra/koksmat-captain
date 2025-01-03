
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot .. ..)) 

write-host "Root: $root"

. "$root/.koksmat/pwsh/check-env.ps1" "PNPAPPID", "PNPSITE", "PNPCERTIFICATE"
. "$root/.koksmat/pwsh/connectors/sharepoint/connect.ps1"

Get-PnPSite