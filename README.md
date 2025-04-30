# Azure virtual network manager

## [Work in progress] Simple deployment of Azure Virtual Network Manager

~~~powershell
Connect-AzAccount -UseDeviceAuthentication
Install-Module -Name Az.Network -Force -AllowClobber

$prefix="cptdazavnm"
$location="northeurope"
for ($i = 0; $i -lt 10; $i++) {
    $vnetName = "spoke$i"
    az network vnet create --name $vnetName --resource-group $prefix --location $location --address-prefixes "10.$i.0.0/16" --subnet-name "subnet$i" --subnet-prefix "10.$i.0.0/24" --tags "vnettype=spoke" --output none
}

# Create a new virtual network for the Azure Firewall
$hubVnetName = "hub"
$hubAddressPrefix = "10.11.0.0/16"
$firewallSubnetName = "AzureFirewallSubnet"
$firewallSubnetPrefix = "10.11.1.0/24"

az network vnet create --name $hubVnetName --resource-group $prefix --location $location --address-prefixes $hubAddressPrefix --subnet-name $firewallSubnetName --subnet-prefix $firewallSubnetPrefix --tags "vnettype=hub" --output none

# Deploy Azure Firewall Basic in the hub virtual network
$firewallName = "hubFirewall"
az network firewall create --name $firewallName --resource-group $prefix --location $location --vnet-name $hubVnetName --sku Basic --output none
~~~

## Misc

### Git

~~~powershell
# Initialize a new Git repository
git init
git status
# Add all files to the repository
git add .

# Commit the changes
git commit -m "Initial commit"

# Create a new repository on GitHub using the GitHub CLI
gh repo create cptdazavnm --public --source . --remote origin

# Push the changes to the GitHub repository
git push -u origin main
~~~