. "$PSScriptRoot/shared.ps1"

$listname = "Hooks"
List $listname
TextField $listname "ResourceUrl" "Resource Url"  $true
CalculatedField $listname "Status" "Status" "=0"
MultiLineTextField $listname "Response" "Response"  $false

$json = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "txtContent": "[$UniqueId]"
}

'@


# Set-PnPField -List $listname -Identity "Execute" -Values @{ CustomFormatter = $json }
# ChoiceField $listname "Permissions" "Permissions"  @("Read", "Read/Write")
# UserField $listname "Owner" "Owner"  $false
# UserField $listname "Contact" "Contact"  $false