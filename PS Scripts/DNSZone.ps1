$rg1 = Get-AzResourceGroup -Name "Az_103-Lab"
$rg2 = Get-AzResourceGroup -Name "Az_103-Lab-2"
$dnsName = "kishaa.mod4"
$vnet1 = Get-AzVirtualNetwork -Name "azmod4-VNet1" -ResourceGroupName $rg1.ResourceGroupName

$vnet2 = Get-AzVirtualNetwork -Name "azmod4-VNet2" -ResourceGroupName $rg2.ResourceGroupName

$zone = New-AzPrivateDnsZone -Name $dnsName -ResourceGroupName $rg2.ResourceGroupName

$vnet1link = New-AzPrivateDnsVirtualNetworkLink -ZoneName $zone.Name -ResourceGroupName $rg2.ResourceGroupName -Name "vnet1Link" -VirtualNetworkId $vnet1.id -EnableRegistration

$vnet2link = New-AzPrivateDnsVirtualNetworkLink -ZoneName $zone.Name -ResourceGroupName $rg2.ResourceGroupName -Name "vnet2Link" -VirtualNetworkId $vnet2.id

New-AzPrivateDnsRecordSet -ResourceGroupName "Az_103-Lab-2" -Name www -RecordType A -ZoneName kishaa.mod4 -Ttl 3600 -PrivateDnsRecords (New-AzPrivateDnsRecordConfig -IPv4Address "10.1.0.10")
