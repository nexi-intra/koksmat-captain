param (
  $secret = "This is a secret"
)
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot ..)) 

. "$root/.koksmat/pwsh/check-env.ps1" "GRAPH_APPID", "GRAPH_APPSECRET", "GRAPH_APPDOMAIN", "OWNER_UPN", "SENDER_UPN", "SPN_CREDS"
. "$root/.koksmat/pwsh/connectors/graph/connect.ps1"

$appInfo = az ad app show --id $env:TARGET_APPID --output json | ConvertFrom-Json

$credential = Convertfrom-json $env:SPN_CREDS
$creds = @{
  "clientSecret"   = $credential.password
  "clientId"       = $credential.appId
  "tenantId"       = $credential.tenant
  "subscriptionId" = $credential.subscriptionId

}

$json = $creds | ConvertTo-Json

$uploadedFile = GraphAPI `
  -token $env:GRAPH_ACCESSTOKEN `
  -method "PUT" `
  -url "https://graph.microsoft.com/v1.0/users/$env:OWNER_UPN/drive/root:/koksmat/apps/azure/$env:GRAPH_APPDOMAIN/$($credential.displayName)/credentials.txt:/content" `
  -headers @{
  "Content-Type" = "text/plain"
} `
  -body @"
# This is JSON representation of the credentials
CREDENTIAL="
$($json)
"

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
    "subject": "Your Service Principal has been updated",
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


