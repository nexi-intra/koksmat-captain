$appName = "$($env:SPN_NAME) [$($env:OWNER_UPN)]"
$roleName = $env:ROLE_NAME
write-host "Creating service principal for $appName and role $roleName"

$spLines = az ad sp create-for-rbac --name  $appName --skip-assignment
$spJSON = $spLines -join "`n"
$sp = convertfrom-json -InputObject $spJSON


$roleJSON = az rest --method GET --url "https://graph.microsoft.com/v1.0/directoryRoles" --query "value[?displayName=='$($roleName)']" 
$role = $roleJSON | convertfrom-json

$spnId = az ad sp list --display-name $appName | convertfrom-json

$body = @"
{ 
    "@odata.type": "#microsoft.graph.unifiedRoleAssignment",
    "roleDefinitionId": "$($role.id)",
    "principalId": "$($spnId.id)",
    "directoryScopeId": "/"
}
"@

az rest --method POST `
  --url "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments" `
  --body $body
 

$env:SPN_CREDS = $spJSON