
# $spLines = az ad sp create-for-rbac --name  "Manage Azure Apps [niels.johansen@nexigroup.com]" --skip-assignment
# $spJSON = $spLines -join "`n"
# $sp = convertfrom-json -InputObject $spJSON


#$sp

#$addData = 

# $app = az ad sp show --id $sp.appId  -o json | convertfrom-json
#az role assignment listaz

$sp