$rg = Get-AzResourceGroup -Name "AZ-Lab-RG"
$containerName = 'azzmod3storage2-container'
$storageAccount1Name = (Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName)[0].StorageAccountName
$storageAccount2Name = (Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName)[1].StorageAccountName
$storageAccount1Key1 = (Get-AzStorageAccountKey -ResourceGroupName $rg.ResourceGroupName -StorageAccountName $storageAccount1Name)[0].Value
$storageAccount2Key1 = (Get-AzStorageAccountKey -ResourceGroupName $rg.ResourceGroupName -StorageAccountName $storageAccount2Name)[0].Value
$context1 = New-AzStorageContext -StorageAccountName $storageAccount1Name -StorageAccountKey $storageAccount1Key1
$context2 = New-AzStorageContext -StorageAccountName $storageAccount2Name -StorageAccountKey $storageAccount2Key1
New-AzStorageContainer -Name $containerName -Context $context2 -Permission Off
$containerToken1 = New-AzStorageContainerSASToken -Context $context1 -ExpiryTime(get-date).AddHours(24) -FullUri -Name $containerName -Permission rwdl
$containerToken2 = New-AzStorageContainerSASToken -Context $context2 -ExpiryTime(get-date).AddHours(24) -FullUri -Name $containerName -Permission rwdl
azcopy cp $containerToken1 $containerToken2 --recursive=true
