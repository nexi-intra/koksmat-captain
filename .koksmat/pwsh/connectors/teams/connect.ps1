# Define the module name
$moduleName = 'MicrosoftTeams'

# Attempt to get the installed module
$module = Get-InstalledModule -Name $moduleName -ErrorAction SilentlyContinue

if ($null -eq $module) {
  # Module is not installed, proceed with installation
  Write-Host "Installing $moduleName..." -ForegroundColor Green
  try {
    Install-Module -Name $moduleName -Force -AllowPrerelease -Scope CurrentUser
    Write-Host "$moduleName has been successfully installed." -ForegroundColor Cyan
  }
  catch {
    Write-Host "Failed to install $moduleName. $_" -ForegroundColor Red
  }
}
else {
  # Module is already installed
  Write-Host "$moduleName is already installed. Version $($module.Version)." -ForegroundColor Yellow
}



Connect-MicrosoftTeams