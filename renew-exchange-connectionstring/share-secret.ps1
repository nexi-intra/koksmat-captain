param (
  $secret = "This is a secret"
)
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot ..)) 

. "$root/.koksmat/pwsh/check-env.ps1" "GRAPH_APPID", "GRAPH_APPSECRET", "GRAPH_APPDOMAIN", "OWNER_UPN", "SENDER_UPN", "TARGET_APPID", "TARGET_ORGANIZATION", "TARGET_DOMAIN"
. "$root/.koksmat/pwsh/connectors/graph/connect.ps1"
$appInfo = az ad app show --id $env:TARGET_APPID --output json | ConvertFrom-Json


$uploadedFile = GraphAPI `
  -token $env:GRAPH_ACCESSTOKEN `
  -method "PUT" `
  -url "https://graph.microsoft.com/v1.0/users/$env:OWNER_UPN/drive/root:/koksmat/apps/azure/$env:GRAPH_APPDOMAIN/$env:TARGET_APPID/exchange-connection.txt:/content" `
  -headers @{
  "Content-Type" = "text/plain"
} `
  -body @"
# This is a base64 encoded pfx file
EXCHORGANIZATION=$env:TARGET_ORGANIZATION
EXCHAPPID=$env:TARGET_APPID
EXCHDOMAIN=$env:TARGET_DOMAIN
EXCHCERTIFICATEPASSWORD=""
EXCHCERTIFICATE=$secret

"@
  
$message = @"
Hi there, a new secret is available for you to use. 

$($uploadedFile.webUrl)

"@
#.Replace("`n", "\\n")

write-host $message


GraphAPI `
  -token $env:GRAPH_ACCESSTOKEN `
  -method "POST" `
  -url "https://graph.microsoft.com/v1.0/users/$env:SENDER_UPN/sendMail" `
  -body @"
{
  "message": {
    "subject": "A new secret is available for app $($appInfo.displayName)",
    "body": {
      "contentType": "Text",
      "content": "$message"
            
    },
    "toRecipients": [
    {
      "emailAddress": {
        "address": "$env:OWNER_UPN"
      }
    }
    ]
  },
 

  "saveToSentItems": "true"
}
"@


