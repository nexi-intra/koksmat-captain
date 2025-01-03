param (
  [string] $ApplicationId ,
  [string] $Subject,
  [string] $certBase64  
)


$appInfo = az ad app show --id $ApplicationId --output json | ConvertFrom-Json

# find the cert
$found = $false
$appInfo.keyCredentials | ForEach-Object {
  if ($_.type -eq "AsymmetricX509Cert") {
    if ($_.displayName -eq $Subject) {
      $found = $true
      return
    }
    
  }
}
if ($found) {
  write-host "Cert already exists" -ForegroundColor Yellow
  return
}

az ad app credential reset --id $ApplicationId --cert $certBase64 --append
# $appInfo.keyCredentials