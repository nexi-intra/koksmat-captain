$ErrorActionPreference = "Stop"

function List($listName) {
  $repoList = Get-PnPList -Identity $listName
  write-host "Checking list $listName" -ForegroundColor Green
  if ($null -eq $repoList) {
    write-host "Creating list $listName" -ForegroundColor Yellow
    $repoList = New-PnPList -Title "$listName" -Template GenericList -OnQuickLaunch
  }
  
}

function TextField($listName, $fieldName, $displayName, $required) {
  $field = Get-PnPField -List $listName -Identity $fieldName -ErrorAction SilentlyContinue
  if ($null -eq $field) {
    write-host "Creating field $fieldName" -ForegroundColor Yellow
    $field = Add-PnPField -List $listName -Type Text -InternalName $fieldName -DisplayName $displayName  -AddToDefaultView -Required:$required
  }
}

function ChoiceField($listName, $fieldName, $displayName, $choices) {
  $field = Get-PnPField -List $listName -Identity $fieldName -ErrorAction SilentlyContinue
  if ($null -eq $field) {
    write-host "Creating field $fieldName" -ForegroundColor Yellow
    $field = Add-PnPField -List $listName -Type Choice -InternalName $fieldName -DisplayName $displayName -Choices $choices -AddToDefaultView
  }
}

try {
  $site = get-pnpsite
  List "Repositories"
  TextField "Repositories" "RepositoryName" "Repository Name"  $true
  TextField "Repositories" "OrganisationName" "Organisation Name"  $true
  ChoiceField "Repositories" "RepositoryType" "Repository Type"  @("Public", "Private")
  TextField "Repositories" "DocRepositoryName" "Documenation Repository Name"  $false
  TextField "Repositories" "DocOrganisationName" "Documenation Organisation Name"  $false
  ChoiceField "Repositories" "DocumentationType" "Documentation Type"  @("Main branch", "All branches", "None")
  
  
  
  
  

  
    
}
catch {
  Write-Host "Error: $_" -ForegroundColor Red
  throw "Setup site Failed - Error: $_"
}
