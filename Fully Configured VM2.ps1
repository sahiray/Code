# Variables for common values
$DC2resourceGroup = "DC-3"
$locationeastus2 = "eastus"

# Create a resource group
New-AzResourceGroup -Name $DC2resourceGroup -Location $locationeastus2

# Create a subnet configuration
$subnetConfigdc3 = New-AzVirtualNetworkSubnetConfig -Name Subnet1 -AddressPrefix 10.10.1.0/24

# Create a virtual network
$vnetdc2 = New-AzVirtualNetwork -ResourceGroupName $DC2resourceGroup -Location $locationeastus2 `
  -Name VNET-DC3 -AddressPrefix 10.10.0.0/16 -Subnet $subnetConfigdc3
