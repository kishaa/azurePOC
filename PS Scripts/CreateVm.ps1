$rg = Get-AzResourceGroup -Name "Az-103-Lab-Kishan"
$vmName = "azllabVMWinDC2"
$vmSize = "Standard_DS2_v2"
$location = "East US"
$vNet = Get-AzVirtualNetwork -Name "azllabvNet" -ResourceGroup $rg.ResourceGroupName
$subnet = (Get-AzVirtualNetworkSubnetConfig -Name 'azllabVnetSubnet2' -VirtualNetwork $vNet).Id
$availabilitySet = Get-AzAvailabilitySet -Name "azllabAvailabilitySet" -ResourceGroup $rg.ResourceGroupName
$nsg = Get-AzNetworkSecurityGroup -Name "azllabNSG" -ResourceGroup $rg.ResourceGroupName
$nic = New-AzNetworkInterface -Name "$vmName-NIC" -ResourceGroup $rg.ResourceGroupName -Location $location -SubnetId $subnet -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id
$pubIP = New-AzPublicIpAddress -Name "$vmName-PublicIP" -Location $location -AllocationMethod Dynamic -ResourceGroup $rg.ResourceGroupName
$adminUsername = 'kishaa'
$adminPassword = 'Welcome@1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)
$publisherName = 'MicrosoftWindowsServer'
$offerName = 'WindowsServer'
$skuName = '2016-Datacenter'
#$osDiskType = (Get-AzDisk -ResourceGroupName $resourceGroup.ResourceGroupName)[0].Sku.Name
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $availabilitySet.Id
Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $adminCreds
Set-AzVMSourceImage -VM $vmConfig -PublisherName $publisherName -Offer $offerName -Skus $skuName -Version 'latest'
Set-AzVMOSDisk -VM $vmConfig -Name "$($vmName)_OsDisk_1_$(Get-Random)" -StorageAccountType $osDiskType -CreateOption fromImage
Set-AzVMBootDiagnostic -VM $vmConfig -Disable
New-AzVM -ResourceGroupName $rg.ResourceGroupName -Location $location -VM $vmConfig
