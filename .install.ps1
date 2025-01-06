write-host "Installing Koksmat Captain Suppport tools" -ForegroundColor Green
push-location 


try {
  set-location (join-path $PSScriptRoot ".koksmat" "web")
  write-host "Installing web dependencies " (get-location) -ForegroundColor Green
  . "./install.ps1"
  set-location  $PSScriptRoot 
  . "./python.ps1"
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

