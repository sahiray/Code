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

# Create a public IP address and specify a DNS name
$pipdc3 = New-AzPublicIpAddress -ResourceGroupName $DC2resourceGroup -Location $locationeastus2 `
  -Name "dc3publicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name nsgRuleAllowRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsgdc3 = New-AzNetworkSecurityGroup -ResourceGroupName $DC2resourceGroup -Location $locationeastus2 `
  -Name NSGDC3 -SecurityRules $nsgRuleRDP

# Create a virtual network card and associate with public IP address and NSG
$nicvm3 = New-AzNetworkInterface -Name NIC-dc3 -ResourceGroupName $DC2resourceGroup -Location $locationeastus2 `
  -SubnetId $vnetdc3.Subnets[0].Id -PublicIpAddressId $pipdc3.Id -NetworkSecurityGroupId $nsgdc3.Id

# Create a virtual machine configuration
$vm3Config = New-AzVMConfig -VMName VM3 -VMSize Standard_B2s | `
Set-AzVMOperatingSystem -Windows -ComputerName VM3 -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nicvm3.Id

# Create a virtual machine
New-AzVM -ResourceGroupName $DC2resourceGroup -Location $locationeastus2 -VM $vm3Config