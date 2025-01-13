<#---
title: Provision SharePoint site for Koksmat
---


#>
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot ..)) 

write-host "Root: $root"

. "$root/.koksmat/pwsh/check-env.ps1" "PNPAPPID", "PNPSITE", "PNPCERTIFICATE", "KOKSMATSITE", "GITHUB_APPID", "GITHUB_ORG"
. "$root/.koksmat/pwsh/connectors/sharepoint/connect.ps1"


Connect-PnPOnline -Url $ENV:KOKSMATSITE -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"


