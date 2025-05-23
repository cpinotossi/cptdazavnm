# Azure Network Manager with Terraform

This project is a simple demo showcasing Azure Virtual Network Manager (AVNM). It demonstrates how to use AVNM's routing and connectivity configurations within an Azure landing zone-like environment. In this setup, each Virtual Network (VNet) is placed in its own subscription, reflecting a common enterprise scenario for network isolation and management. The included scripts and Terraform configurations illustrate how to register required providers, initialize infrastructure, and manage network configurations (such as routing and connectivity) across multiple subscriptions using AVNM. This helps users understand how to centrally manage and secure network traffic in complex Azure environments.

![Azure Hub-and-Spoke Topology (1 Hub, 3 Spokes)](./azure-hub-spoke.svg)

## Deployment

~~~powershell
cd simple.avnm # changfe to this directory if not already there
az login --use-device-code
# register the needed provider on management group level
az provider register -n Microsoft.Network -m "cptdx.net"
az provider register -n Microsoft.Network -m "landingzones"

$subscriptionId = az account show --query "id" -o tsv
$env:TF_VAR_subscription_id = $subscriptionId
tf init
tf init -upgrade
tf fmt
tf validate
# tf destroy --auto-approve
tf plan --out=01.tfplan

tf destroy --auto-approve
tf apply --auto-approve
~~~

## Open points
- Deployment of routing has been done with AzAPI, need to wait till it can be done with the azurerm provider
- Need to clarify how to use Azure Virtual Network Manager in a multi tenant environment
- Which is the best way to define groups, is the Tag the best option, if yes, how to prevent tag modification?
- Even if we can use Network Groups in multiple Network Manager, I would avoid it if possible to keep things simple.
- Which are the cost related to the IPAM?
- Changes done after the initial deployment did not result into a new AVNM deployment, I need to check if I need to create a new deployment instance after each change. If yes, is it it all a good idea to keep the deployment as IaC?

## [Not Working] Deplyoment of Routing Configurations 

~~~powershell
# List all routing configurations in the network manager
$location = (Get-Content -Path "terraform.tfvars.json" -Raw | ConvertFrom-Json).location
$prefix = (Get-Content -Path "terraform.tfvars.json" -Raw | ConvertFrom-Json).prefix
$subId = (Get-Content -Path "terraform.tfvars.json" -Raw | ConvertFrom-Json).subscription_id
az account set --subscription $subId
az network manager routing-config list -g $prefix --manager-name $prefix --query "[].{Name:name, Id:id}" -o table
$routingConfigName="routing-config-hubspoke"
$routingConfigId=az network manager routing-config show -g $prefix --manager-name $prefix -n $routingConfigName --query "id" -o tsv
az network manager post-commit --network-manager-name $prefix --commit-type "Routing" --configuration-ids $routingConfigId --target-locations $location -g $prefix --subscription $subId --verbose 
# post commit
az network manager post-commit --network-manager-name $prefix --commit-type "Routing" --configuration-ids "/subscriptions/<subscriptionID>/resourceGroups/resource-group/providers/Microsoft.Network/networkManagers/network-manager/connectivityConfigurations/connectivityconfig" --target-locations "westus2" --resource-group "resource-group"
# List all routing configurations in the network manager
az network manager routing-config list -g $prefix --manager-name $prefix --query "[].{Name:name, Id:id}" -o table
# List all routing configurations in the network manager
az network manager routing-config list
# Ensure the network manager name is correctly replaced in the URI
$networkManagerName = "cptdavnm" # Replace with the actual network manager name
# Construct the URI dynamically
$uri = "https://management.azure.com/subscriptions/4b353dc5-a216-485d-8f77-a0943546b42c/resourceGroups/cptdavnm/providers/Microsoft.Network/networkManagers/$networkManagerName/deployments/commit-routing-deployment?api-version=2024-05-01"

# Execute the REST API call
az rest --method put --uri $uri --body $body --verbose

$subId = (Get-Content -Path "terraform.tfvars.json" -Raw | ConvertFrom-Json).subscription_id
az network manager post-commit --commit-type Routing --target-locations "northeurope" --configuration-ids "/subscriptions/4b353dc5-a216-485d-8f77-a0943546b42c/resourceGroups/cptdavnm/providers/Microsoft.Network/networkManagers/cptdavnm/routingConfigurations/routing-config-hubspoke" --name "commit-routing-deployment" --resource-group "cptdavnm" --subscription $subId --verbose
~~~

# misc

## terraform

### Terraform Debug

~~~powershell
TF_LOG=debug TF_LOG_FILE=debug.log
~~~

### Analyz flow logs for ICMP traffic been blocked

~~~powershell
# Define the path to the flow log file
$flowLogFilePath = "c:\Users\chpinoto\Downloads\PT1H (5).json"

# Read the flow log file
$flowLogContent = Get-Content -Path $flowLogFilePath -Raw | ConvertFrom-Json

# Initialize an array to store ICMP-related entries
$icmpEntries = @()

# Iterate through the flow records to find ICMP traffic
foreach ($record in $flowLogContent.records) {
    foreach ($flow in $record.flowRecords.flows) {
        foreach ($flowGroup in $flow.flowGroups) {
            foreach ($flowTuple in $flowGroup.flowTuples) {
                # Split the flow tuple into its components
                $tupleParts = $flowTuple -split ","
                
                # Check if the protocol is ICMP (protocol number 1)
                if ($tupleParts[5] -eq "1") {
                    # Add the ICMP entry to the array
                    $icmpEntries += [PSCustomObject]@{
                        Timestamp       = $tupleParts[0]
                        SourceIP        = $tupleParts[1]
                        DestinationIP   = $tupleParts[2]
                        Protocol        = $tupleParts[5]
                        Action          = $tupleParts[6] # 'A' for allowed, 'D' for denied
                        Rule            = $flowGroup.rule
                    }
                }
            }
        }
    }
}

# Output the ICMP entries
if ($icmpEntries.Count -eq 0) {
    Write-Host "No ICMP traffic found in the flow log."
} else {
    Write-Host "ICMP traffic found:"
    $icmpEntries | Format-Table -AutoSize
}
~~~

### Deployment Issues

~~~powershell
# Azure AD SSH extension for VM did run into issues but has been finally deployed. We needed to resolve the drivt via tf import command..
terraform import module.spoke1_vm.azurerm_virtual_machine_extension.aad_ssh /subscriptions/4b353dc5-a216-485d-8f77-a0943546b42c/resourceGroups/cptdavnm/providers/Microsoft.Compute/virtualMachines/cptdavnms1/extensions/cptdavnms1
terraform import module.hub1_vm.azurerm_virtual_machine_extension.aad_ssh /subscriptions/4b353dc5-a216-485d-8f77-a0943546b42c/resourceGroups/cptdavnm/providers/Microsoft.Compute/virtualMachines/cptdavnmh1/extensions/cptdavnmh1
~~~

Deployment did run into the following issues:

╷
│ Error: creating Security Rule (Subscription: "4b353dc5-a216-485d-8f77-a0943546b42c"
│ Resource Group Name: "cptdavnm"
│ Network Security Group Name: "cptdavnm-nsg"
│ Security Rule Name: "Allow-ICMP"): polling after CreateOrUpdate: polling was cancelled: the Azure API returned the following error:   
│
│ Status: "Canceled"
│ Code: "CanceledAndSupersededDueToAnotherOperation"
│ Message: "Operation was canceled.\nOperation PutSecurityRuleOperation (2f130ac5-5e21-455a-a4b1-f2009bca24cc) was canceled and superseded by operation PutSecurityRuleOperation (8da7af9d-879b-4a30-9839-7fa094257a3a)."
│ Activity Id: ""
│
│ ---
│
│ API Response:
│
│ ----[start]----
│ {"status":"Canceled","error":{"code":"Canceled","message":"Operation was canceled.","details":[{"code":"CanceledAndSupersededDueToAnotherOperation","message":"Operation PutSecurityRuleOperation (2f130ac5-5e21-455a-a4b1-f2009bca24cc) was canceled and superseded by operation PutSecurityRuleOperation (8da7af9d-879b-4a30-9839-7fa094257a3a)."}]}}
│ -----[end]-----
│
│
│   with azurerm_network_security_rule.allow_icmp_inbound,
│   on nsg.tf line 9, in resource "azurerm_network_security_rule" "allow_icmp_inbound":
│    9: resource "azurerm_network_security_rule" "allow_icmp_inbound" {

Afterwards, we needed to clean up some resources manually in the Azure portal.