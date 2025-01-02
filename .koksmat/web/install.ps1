write-host "Installing dependencies" -ForegroundColor Green
push-location 
set-location $PSScriptRoot

try {
  pnpm install
}
catch {
  write-host "--- ERROR ---------------------"  -ForegroundColor Red
  Write-Host "ERROR" $_  -ForegroundColor Red
  write-host "-------------------------------"  -ForegroundColor Red
}
finally {
  Write-Host "Installing dependencies"
}
pop-location

