
$root = [System.IO.Path]::GetFullPath(( join-path $PSScriptRoot .. ..)) 

write-host "Root: $root"

. "$root/.koksmat/pwsh/check-env.ps1" "EXCHAPPID", "EXCHORGANIZATION", "EXCHCERTIFICATE"
. "$root/.koksmat/pwsh/connectors/exchange/connect.ps1"

get-mailbox -resultsize 2