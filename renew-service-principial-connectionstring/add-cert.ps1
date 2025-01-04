param (
  [string] $ApplicationId,
  [string] $Subject,
  [string] $certBase64
)

$certBytes = [System.Convert]::FromBase64String($certBase64)

# Compute SHA-256 hash
$sha1 = [System.Security.Cryptography.SHA1]::Create()
$hashBytes = $sha1.ComputeHash($certBytes)
$hashString = -join ($hashBytes | ForEach-Object { $_.ToString("x2") })
Write-Output "SHA-1 Hash: $hashString"

#return

$appInfo = az ad app show --id $ApplicationId --output json | ConvertFrom-Json

# find the cert
$found = $false
$appInfo.keyCredentials | ForEach-Object {
  if ($_.type -eq "AsymmetricX509Cert") {
    
    if ($_.customKeyIdentifier -eq $hashString) {
      $found = $true
      return
    }
  }
}
if ($found) {
  write-host "Cert already exists with hash $hashString" -ForegroundColor Yellow
  return
}
try {
  $result = az ad app credential reset --id $ApplicationId  --cert $certBase64 --append 
  if (!$result) {
    throw "Failed to add certificate to app error: $_"
  }
  
}
catch {
  throw "Failed to add certificate to app $ApplicationId $($_.Exception.Message)"
}

# $appInfo.keyCredentials