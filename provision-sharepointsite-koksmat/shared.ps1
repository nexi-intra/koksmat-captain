$ErrorActionPreference = "Stop"

function List($listName) {
  $repoList = Get-PnPList -Identity $listName -ErrorAction SilentlyContinue
  write-host "Checking list $listName" -ForegroundColor Green
  if ($null -eq $repoList) {
    write-host "Creating list $listName" -ForegroundColor Yellow
    $repoList = New-PnPList -Title "$listName" -Template GenericList -OnQuickLaunch
  }
  
}
function DocumentLibrary($listName) {
  $repoList = Get-PnPList -Identity $listName -ErrorAction SilentlyContinue
  write-host "Checking list $listName" -ForegroundColor Green
  if ($null -eq $repoList) {
    write-host "Creating list $listName" -ForegroundColor Yellow
    $repoList = New-PnPList -Title "$listName" -Template DocumentLibrary -OnQuickLaunch
  }
  
}

function TextField($listName, $fieldName, $displayName, $required) {
  $field = Get-PnPField -List $listName -Identity $fieldName -ErrorAction SilentlyContinue
  if ($null -eq $field) {
    write-host "Creating field $fieldName" -ForegroundColor Yellow
    $field = Add-PnPField -List $listName -Type Text -InternalName $fieldName -DisplayName $displayName  -AddToDefaultView -Required:$required
  }
}
function MultiLineTextField($listName, $fieldName, $displayName, $required) {
  $field = Get-PnPField -List $listName -Identity $fieldName -ErrorAction SilentlyContinue
  if ($null -eq $field) {
    write-host "Creating field $fieldName" -ForegroundColor Yellow
    $field = Add-PnPField -List $listName -Type Note  -InternalName $fieldName -DisplayName $displayName  -AddToDefaultView -Required:$required
  }
}

function ChoiceField($listName, $fieldName, $displayName, $choices) {
  $field = Get-PnPField -List $listName -Identity $fieldName -ErrorAction SilentlyContinue
  if ($null -eq $field) {
    write-host "Creating field $fieldName" -ForegroundColor Yellow
    $field = Add-PnPField -List $listName -Type Choice -InternalName $fieldName -DisplayName $displayName -Choices $choices -AddToDefaultView
  }
}

function CalculatedField($listName, $fieldName, $displayName, $formula) {
  $field = Get-PnPField -List $listName -Identity $fieldName -ErrorAction SilentlyContinue
  if ($null -eq $field) {
    write-host "Creating field $fieldName" -ForegroundColor Yellow
    $field = Add-PnPField -List $listName -Type Calculated -InternalName $fieldName -DisplayName $displayName -Formula $formula -AddToDefaultView
  }
  else {
    write-host "Updating field $fieldName" -ForegroundColor Yellow
    Set-PnPField -List $listName -Identity $fieldName -Values @{ Formula = $formula }
  }
}

function UserField($listName, $fieldName, $displayName, $required) {
  $field = Get-PnPField -List $listName -Identity $fieldName -ErrorAction SilentlyContinue
  if ($null -eq $field) {
    write-host "Creating field $fieldName" -ForegroundColor Yellow
    $field = Add-PnPField -List $listName -Type User -InternalName $fieldName -DisplayName $displayName -AddToDefaultView -Required:$required
  }
}
function AddTemplate($libraryName, $fileName) {
  # Upload the template to the Forms folder
  Write-Host "Uploading the template..." -ForegroundColor Green
  Add-PnPFile -Path $templatePath -Folder "$libraryName/Forms"

  # Set the uploaded file as the default template
  Write-Host "Setting the default template..." -ForegroundColor Green
  Set-PnPList -Identity $libraryName -DocumentTemplate "Forms/YourTemplate.dotx"

}