. "$PSScriptRoot/shared.ps1"

List "Repositories"
TextField "Repositories" "RepositoryName" "Repository Name"  $true
TextField "Repositories" "OrganisationName" "Organisation Name"  $true
ChoiceField "Repositories" "RepositoryType" "Repository Type"  @("Public", "Private")
TextField "Repositories" "DocRepositoryName" "Documenation Repository Name"  $false
TextField "Repositories" "DocOrganisationName" "Documenation Organisation Name"  $false
ChoiceField "Repositories" "DocumentationType" "Documentation Type"  @("Main branch", "All branches", "None")
CalculatedField "Repositories" "GitHub" "GitHub"  @"
=CONCATENATE("https://github.com","/",[Organisation Name],"/",[Repository Name])
"@
CalculatedField "Repositories" "Actions" "Actions"  @"
=1
"@


$json = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/column-formatting.schema.json",
  "elmType": "a",
  "attributes": {
    "href": "@currentField",
    "target": "_blank"
  },
  "txtContent": "@currentField",
  "style": {
    "color": "#0072C6",
    "text-decoration": "underline"
  }
}
'@

Set-PnPField -List "Repositories" -Identity "GitHub" -Values @{ CustomFormatter = $json }

$json = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/column-formatting.schema.json",
  "elmType": "a",
  "attributes": {
    "href": "@currentField",
    "target": "_blank"
  },
  "txtContent": "@currentField",
  "style": {
    "color": "#0072C6",
    "text-decoration": "underline"
  }
}
'@

Set-PnPField -List "Repositories" -Identity "GitHub" -Values @{ CustomFormatter = $json }


$json = @'
{
  "elmType": "div",
  "style": {
    "font-size": "12px"
  },
  "txtContent": "[$Status]",
  "customCardProps": {
    "formatter": {
      "elmType": "div",
      "txtContent": "Define your formatter options inside the customCardProps/formatter property"
    },
    "openOnEvent": "hover",
    "directionalHint": "bottomCenter",
    "isBeakVisible": true,
    "beakStyle" : {
      "backgroundColor": "white"
    }
  }
}

'@

Set-PnPField -List "Repositories" -Identity "Actions" -Values @{ CustomFormatter = $json }
