<#---
title: Provision a service principal
---

#>
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot ..)) 

. "$root/.koksmat/pwsh/check-env.ps1" "GRAPH_APPID", "GRAPH_APPSECRET", "GRAPH_APPDOMAIN", "OWNER_UPN", "TARGET_APPNAME", "ROLENAME"
. "$PSScriptRoot/provision.ps1"
. "$PSScriptRoot/share-secret.ps1" 

try {

}
catch {
  write-host "Error: $_" -ForegroundColor:Red
  
}

