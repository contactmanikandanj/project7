# Step 1: Connect to Azure using Azure PowerShell
Connect-AzAccount

# Step 2: Create a resource group to contain the VM
New-AzResourceGroup -Name "MyResourceGroup" -Location "East US"

# Step 3: Create a virtual network for the VM
New-AzResourceGroup -Name TestResourceGroup -Location centralus
$frontendSubnet = New-AzVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix "10.0.1.0/24"
$backendSubnet  = New-AzVirtualNetworkSubnetConfig -Name backendSubnet  -AddressPrefix "10.0.2.0/24"
New-AzVirtualNetwork -Name MyVirtualNetwork -ResourceGroupName TestResourceGroup -Location centralus -AddressPrefix "10.0.0.0/16" -Subnet $frontendSubnet,$backendSubnet

# Step 4: Create a subnet within the virtual network
$networkSecurityGroup = Get-AzNetworkSecurityGroup -ResourceGroupName "YourResourceGroup" -Name "YourNSG"
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name "YourSubnet" -AddressPrefix "10.0.0.0/24" -NetworkSecurityGroup $networkSecurityGroup
$virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName "YourResourceGroup" -Name "YourVirtualNetwork"
$virtualNetwork | Add-AzVirtualNetworkSubnetConfig -Name "YourSubnet" -AddressPrefix "10.0.0.0/24" -Subnet $subnetConfig
$virtualNetwork | Set-AzVirtualNetwork

# Step 5: Create a public IP address for the VM
$publicIp = New-AzPublicIpAddress -Name "MyPublicIp" -ResourceGroupName "MyResourceGroup" -AllocationMethod "Static" -Location "East US"

# Step 6: Create a network security group for the VM
$rule1 = New-AzNetworkSecurityRuleConfig -Name "rdp-rule" -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
$rule2 = New-AzNetworkSecurityRuleConfig -Name "web-rule" -Description "Allow HTTP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName "TestRG" -Location "westus" -Name "NSG-FrontEnd" -SecurityRules $rule1,$rule2

# Step 7: Create a network interface for the VM
New-AzNetworkInterface -Name "NetworkInterface1" -ResourceGroupName "ResourceGroup1" -Location "centralus" -SubnetId "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/ResourceGroup1/providers/Microsoft.Network/virtualNetworks/VirtualNetwork1/subnets/Subnet1" -IpConfigurationName "IPConfiguration1" -DnsServer "8.8.8.8", "8.8.4.4"

# Step 8: Create a virtual machine in the resource group with the specified configuration
$resourceGroupName = "Free Trial"
$location = "EastUS"
$vmName = "TestUser1"
$credential = Get-Credential
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -Name $vmName -Credential $credential
