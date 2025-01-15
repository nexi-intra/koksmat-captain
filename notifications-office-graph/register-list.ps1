<#---
title: Register List
---

This script registers a SharePoint list for notifications using the Office Graph API.

#>
param (
  $listUrl = "https://christianiabpos.sharepoint.com/sites/nexiintra-country-it/Lists/Applications/AllItems.aspx"
)

. "$root/.koksmat/pwsh/check-env.ps1" "GRAPH_APPID", "GRAPH_APPSECRET", "GRAPH_APPDOMAIN", "REQUEST", "PNPAPPID", "PNPTENANTID", "PNPCERTIFICATE", "KOKSMATSITE", "NOTICATION_URL"
. "$root/.koksmat/pwsh/connectors/graph/connect.ps1"

$notificationUrl = $env:NOTICATION_URL

$url = $listUrl.ToLower()
$hostUrl = $url.Split("/sites/")[0]
$siteUrl = $url.Split("/lists/")[0]
$siteName = $url.Split("/sites/")[1].Split("/")[0]
$listName = $url.Split("/lists/")[1].Split("/")[0]


Connect-PnPOnline -Url $ENV:KOKSMATSITE -ClientId $PNPAPPID -Tenant $PNPTENANTID -CertificatePath "$PNPCERTIFICATEPATH"
write-host "List registration for site $($siteUrl) and list $listName"


<#

## Getting list from the site
#>

$accessToken = $env:GRAPH_ACCESSTOKEN

$siteId = FindSiteIdByUrl $accessToken $siteUrl


# Define the lists endpoint
$listsEndpoint = "https://graph.microsoft.com/v1.0/sites/$siteId/lists"

# Get all lists
$lists = GraphAPI $accessToken "GET" $listsEndpoint

$listId = ""

foreach ($list in $lists.value) {
  if ($list.displayName.ToLower() -eq $listName.ToLower()) {
    Write-Output "List Title: $($list.displayName) - List ID: $($list.id)"
    $listId = $list.id
  }
  
}

if ($listId -eq "") {
  throw "List not found"
  
}

<#

## Setup subscription
Create Subscription Body
#>

$expirationDateTime = (Get-Date).AddDays(2).ToString("o")  # Adjust based on Graph API limits
# https://learn.microsoft.com/en-us/graph/api/subscription-post-subscriptions?view=graph-rest-1.0&tabs=http#resources-examples
$resource = "sites/$siteId/lists/$listId"

# https://learn.microsoft.com/en-us/graph/api/resources/changenotification?view=graph-rest-1.0#properties
$subscriptionBody = @{
  changeType         = "updated"
  notificationUrl    = $notificationUrl
  resource           = $resource
  expirationDateTime = $expirationDateTime
  clientState        = $clientState
} | ConvertTo-Json

# Create Subscription
$graphApiEndpoint = "https://graph.microsoft.com/v1.0/subscriptions"

$subscriptionResponse = Invoke-RestMethod -Method Post -Uri $graphApiEndpoint -Headers @{ Authorization = "Bearer $accessToken" } -Body $subscriptionBody -ContentType "application/json"
if ($null -eq $subscriptionResponse) {
  throw "Subscription not created"
}
<#
### Register in SharePoint list
#>

$listItem = Get-PnpListItem -List "Hooks" -Query "<View><Query><Where><Eq><FieldRef Name='Title' /><Value Type='Text'>$($listUrl)</Value></Eq></Where></Query></View>"
$response = ConvertTo-Json -InputObject $subscriptionResponse -Depth 10
if ($listItem -eq $null) {
  write-host "Registering new hook"
  $listItem = Add-PnPListItem -List "Hooks" -Values @{"Title" = $listUrl; "ResourceUrl" = $resource; "Status" = "1"; "Response" = $response }
}
else {
  $listItem = Set-PnPListItem -List "Hooks" -Identity $listItem.Id -Values @{"ResourceUrl" = $resource; "Status" = "1"; "Response" = $response }
  write-host "Updating hook"
}
$listItem


# Output Subscription Details
Write-Output "Subscription Created:"
Write-Output "ID: $($subscriptionResponse.id)"
Write-Output "Resource: $($subscriptionResponse.resource)"
Write-Output "Notification URL: $($subscriptionResponse.notificationUrl)"
Write-Output "Expiration: $($subscriptionResponse.expirationDateTime)"
Write-Output "Client State: $($subscriptionResponse.clientState)"



