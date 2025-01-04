. (join-path  $PSScriptRoot ".." ".." ".koksmat" "pwsh" "koksmat.ps1")

Push-Location
try {
  Set-Location $PSScriptRoot
  
  $pfx = Get-Content -Path (join-path $PSScriptRoot ".." ".." ".koksmat" "workdir" "certs" "app.b64pfx") -Raw 
  @"
APP_APPLICATION_CERTIFICATE=$pfx
APP_APPLICATION_ID=0ab48e1a-3543-44c3-916c-e64dd7b2835c
APP_APPLICATION_DOMAIN=79dc228f-c8f2-4016-8bf0-b990b6c72e98
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