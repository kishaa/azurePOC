$rg = Get-AzResourceGroup -Name "Az-103-Lab-Kishan"
$vmName = "azVMwinDC2"
$vmSize = "Standard_DS2_v2"
$location = "East US"
$vNet = New-AzVirtualNetwork -Name "$vmName-VNet" -ResourceGroup $rg.ResourceGroupName
$subnet = (New-AzVirtualNetworkSubnetConfig -Name 'default' -VirtualNetwork $vNet).Id
$availabilitySet = New-AzAvailabilitySet -Name "$vmName-AvailSet" -ResourceGroup $rg.ResourceGroupName
$nsg = New-AzNetworkSecurityGroup -Name "$vmName-NSG" -ResourceGroup $rg.ResourceGroupName
$nic = New-AzNetworkInterface -Name "$vmName-NIC" -ResourceGroup $rg.ResourceGroupName -Location $location -SubnetId $subnet -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id
$pubIP = New-AzPublicIpAddress -Name "$vmName-PubIP" -Location $location -AllocationMethod Dynamic -ResourceGroup $rg.ResourceGroupName
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
