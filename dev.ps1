write-host "Starting development mode" -ForegroundColor Green
push-location 
set-location (join-path $PSScriptRoot ".koksmat" "web")

try {
  Activate-Or-Create-Venv                                             
  write-host "Running development mode " (get-location) -ForegroundColor Green
  pnpm run dev
}
catch {
  write-host "--- ERROR ---------------------"  -ForegroundColor Red
  Write-Host "ERROR" $_  -ForegroundColor Red
  write-host "-------------------------------"  -ForegroundColor Red
}
finally {
  
}

pop-location
write-host "Koksmat Captain Suppport tools installed" -ForegroundColor Green

