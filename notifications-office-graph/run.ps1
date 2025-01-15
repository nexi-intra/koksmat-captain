<#---
title: Manage Notifications with Office Graph
---

#>
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot ..)) 

. "$root/.koksmat/pwsh/check-env.ps1" "GRAPH_APPID", "GRAPH_APPSECRET", "GRAPH_APPDOMAIN", "REQUEST", "PNPAPPID", "PNPTENANTID", "PNPCERTIFICATE", "KOKSMATSITE"

$args = $env:REQUEST.Split(",")  #| ConvertFrom-Csv

$action = $args[0].ToUpper()

write-host "Action: $action"
switch ($action) {
  "REGISTER" { 
    . "$PSScriptRoot/register-$($args[1]).ps1"  $args[2]
  }
  Default {
    
    Throw "Unknown action"
  }
}
