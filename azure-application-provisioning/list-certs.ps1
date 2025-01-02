param (
  [string] $ApplicationId = "d7e7315a-17fc-444e-bb8b-c299a5f66fc5"
)


# $appInfo = az ad app show --id $ApplicationId --output json | ConvertFrom-Json
$path = (join-path $PSScriptRoot ".."  ".koksmat" "workdir" "certs" "exchange.b64cer")
$certPath = resolve-path $path
$cert = Get-Content -Path $certPath -Raw
write-host $certPath 
az ad app credential reset --id $ApplicationId --cert $cert --append
# $appInfo.keyCredentials