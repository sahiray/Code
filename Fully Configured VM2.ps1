# Variables for common values
$DC2resourceGroup = "DC-4"
$locationeastus2 = "eastus"

# Create a resource group
New-AzResourceGroup -Name $DC2resourceGroup -Location $locationeastus2

# Create a subnet configuration
$subnetConfigdc4 = New-AzVirtualNetworkSubnetConfig -Name Subnet1 -AddressPrefix 49.10.10.0/24

# Create a virtual network
$vnetdc4 = New-AzVirtualNetwork -ResourceGroupName $DC2resourceGroup -Location $locationeastus2 `
  -Name VNET-DC4 -AddressPrefix 49.10.0.0/16 -Subnet $subnetConfigdc3
