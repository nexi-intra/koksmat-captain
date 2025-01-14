$token = az account get-access-token | ConvertFrom-Json
$token.accessToken
$tokenParts = $token.accessToken.Split('.')
if ($tokenParts.Count -lt 2) {
  Throw "Invalid token. JWT must have at least two parts (header and payload)."
}

$payload = $tokenParts[1]

$bytes = [Convert]::FromBase64String($payload)
$decodedString = [System.Text.Encoding]::UTF8.GetString($bytes)
$decodedPayload = $decodedString | convertfrom-json
Write-Host "Decoded JWT payload:"