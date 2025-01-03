. (join-path  $PSScriptRoot ".." ".." ".koksmat" "pwsh" "koksmat.ps1")

Push-Location
try {
  Set-Location $PSScriptRoot
  
  $pfx = Get-Content -Path (join-path $PSScriptRoot ".." ".." ".koksmat" "workdir" "certs" "sharepoint.b64pfx") -Raw 
  @"
PNPCERTIFICATE=$pfx
"@ | Out-File -FilePath (join-path $PSScriptRoot ".env") 
  
  . "$PSScriptRoot/../../.koksmat/pwsh/build-env.ps1"
  . "$PSScriptRoot/temp.ps1"
  . "$PSScriptRoot/run.ps1"
}
catch {
  write-host "Error: $_" -ForegroundColor:Red
  <#Do this if a terminating exception happens#>
}
finally {
  Pop-Location
}