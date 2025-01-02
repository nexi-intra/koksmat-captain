function Open-KM-PythonEnvironment {
  <#
  .SYNOPSIS
  Checks for a .venv directory, creates it if absent, and activates the Python virtual environment.

  .DESCRIPTION
  This function automates the process of managing Python virtual environments. It checks for the presence of a .venv folder in the current directory. If the folder does not exist, it creates a new virtual environment using Python's venv module. It then activates the virtual environment. The activation method differs based on the operating system.

  .PARAMETER None

  .EXAMPLE
  Activate-Or-Create-Venv
  #>

  # Define the virtual environment directory name
  $venvDir = ".venv"

  # Check if the .venv directory exists
  if (-Not (Test-Path -Path $venvDir)) {
    Write-Host "🚀 .venv directory not found. Creating a new virtual environment..." -ForegroundColor Cyan
    try {
      if ($isWindows) {
        python -m venv $venvDir
      }
      else {
        python3 -m venv $venvDir
      }
      Write-Host "✅ Virtual environment '.venv' created successfully." -ForegroundColor Green
    }
    catch {
      Write-Host "❌ Failed to create virtual environment. Ensure Python is installed and accessible." -ForegroundColor Red
      Write-Error $_
      return
    }
  }
  else {
    Write-Host "🔍 Found existing '.venv' directory." -ForegroundColor Yellow
  }

  # Determine the operating system
  # $isWindows = $IsWindows

  
  # Define the activation script path for Windows
  $activateScript = Join-Path -Path $venvDir  "bin" "Activate.ps1"

  # Check if the activation script exists
  if (Test-Path -Path $activateScript) {
    try {
      # Activate the virtual environment by dot-sourcing the script
      . "$activateScript"
      Write-Host "✅ Activated virtual environment '.venv'." -ForegroundColor Green
    }
    catch {
      Write-Host "❌ Failed to activate the virtual environment." -ForegroundColor Red
      Write-Error $_
    }
  }
  else {
    Write-Host "❌ Activation script not found at '$activateScript'." -ForegroundColor Red
    Write-Host "👉 Ensure that the virtual environment was created correctly." -ForegroundColor Yellow
  }
  
}
function Close-KM-PythonEnvironment {
  <#
  .SYNOPSIS
  Deactivates the currently active Python virtual environment.

  .DESCRIPTION
  This function checks if a Python virtual environment is active by inspecting the VIRTUAL_ENV environment variable.
  If a virtual environment is active, it invokes the 'deactivate' function to deactivate it.
  It provides clear, color-coded feedback to the user about the deactivation status.

  .PARAMETER None

  .EXAMPLE
  Deactivate-Venv
  #>

  # Check if the VIRTUAL_ENV environment variable is set
  if ($env:VIRTUAL_ENV) {
    # Attempt to call the 'deactivate' function
    try {
      if (Get-Command deactivate -ErrorAction SilentlyContinue) {
        deactivate
        Write-Host "✅ Virtual environment deactivated successfully." -ForegroundColor Green
      }
      else {
        Write-Host "❌ The 'deactivate' command is not available. Ensure that a virtual environment is active and the activation script has been sourced correctly." -ForegroundColor Red
      }
    }
    catch {
      Write-Host "❌ An error occurred while attempting to deactivate the virtual environment." -ForegroundColor Red
      Write-Error $_
    }
  }
  else {
    Write-Host "❌ No virtual environment is currently active." -ForegroundColor Yellow
  }
}


