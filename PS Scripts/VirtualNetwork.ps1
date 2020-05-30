$rg1 = Get-AzResourceGroup -Name "Az_103-Lab"
$rg2 = Get-AzResourceGroup -Name "Az_103-Lab-2"
$location = "East US"
$vNet1 = "azmod4-VNet1"
$vNet2 = "azmod4-VNet2"
$Address1 = "10.0.0.0/16"
$Address2 = "10.1.0.0/16"
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name "azmod4-Subnet1" -AddressPrefix '10.0.0.0/24'
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name "azmod4-Subnet2" -AddressPrefix '10.1.0.0/24'
$vnet1 = New-AzVirtualNetwork -ResourceGroupName $rg1.ResourceGroupName `
 -Location $rg1.Location `
 -Name "azmod4-VNet1" `
 -AddressPrefix $Address1 -Subnet $subnet1
 $vnet2 = New-AzVirtualNetwork -ResourceGroupName $rg2.ResourceGroupName `
  -Location $rg2.Location `
  -Name "azmod4-VNet2" `
  -AddressPrefix $Address2 -Subnet $subnet2
