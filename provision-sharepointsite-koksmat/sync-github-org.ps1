$ErrorActionPreference = "Stop"

# try {

$site = get-pnpsite
#List "Repositories"
  
$orgName = "nexi-intra"

$repos = gh repo list $orgName --json "name,visibility" --limit 999 | ConvertFrom-Json

$repoDictionary = @{}
# Populate the dictionary with keys in the format "orgName/repoName"
foreach ($repo in $repos) {
  $key = "$orgName/$($repo.name)"
  $repoDictionary[$key] = $repo
}

#get-pnplist "repositories"
Get-PnPListItem -List "Repositories" 
foreach ($repo in $repos) {
  #  write-host $repo.name
}

# Retrieve all items from the SharePoint list "Repositories"
$listItems = Get-PnPListItem -List "Repositories"

# Iterate through SharePoint list items and compare with the dictionary
foreach ($item in $listItems) {
  # Construct the key from SharePoint item fields
  $listOrgName = $item.FieldValues["OrganisationName"]  # Replace with your actual SharePoint field name
  $listRepoName = $item.FieldValues["RepositoryName"]  # Replace with your actual SharePoint field name
  $key = "$listOrgName/$listRepoName"

  if ($repoDictionary.ContainsKey($key)) {
    Write-Host "Match found for key: $key" -ForegroundColor Green
  }
  else {
    Write-Host "No match found for key: $key in the dictionary" -ForegroundColor Red
  }
}

# Check for repositories in the dictionary that are not in the SharePoint list
foreach ($key in $repoDictionary.Keys) {
  $found = $listItems | Where-Object {
    "$($_.FieldValues["OrganisationName"])/$($_.FieldValues["RepositoryName"])" -eq $key
  }
  if (-not $found) {
    Write-Host "Repository in dictionary but not in SharePoint: $key" -ForegroundColor Yellow
    Add-PnPListItem -List "Repositories" -Values @{
      "Title"            = $key
      "OrganisationName" = $orgName
      "RepositoryName"   = $repoDictionary[$key].name
      "RepositoryType"   = $repoDictionary[$key].visibility
    }
  }
}
  
  
  

  
    
# }
# catch {
#   Write-Host "Error: $_" -ForegroundColor Red
#   throw "Sync repos failed - Error: $_"
# }
