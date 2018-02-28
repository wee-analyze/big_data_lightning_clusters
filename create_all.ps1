# för att skapa måste vi först skapa resursgrupp, storage konto och container. Sedan får vi skapa kluster.
Write-Host "creating resource group..."
$ResourceName = "namnge_resource"
$Location = "North Europe"  #locations: Southeast Asia, North Europe, West Europe, East US, or West US
# skapa resurgrupp
New-AzureRmResourceGroup -name $ResourceName -location $Location

write-Host "creating storage account..."
$StorageName = "namnge_storage"
# skapa Storage Account i den nya resursgruppen
New-AzureRmStorageAccount -ResourceGroupName $ResourceName `
						  -AccountName $StorageName `
						  -SkuName Standard_LRS `
						  -location $Location


# Innan vi skapar container måste vi Skapa variable för nyckeln och context object för 
# att kunna ansluta till storage account (steg 1)
$StorageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceName `
											-Name $StorageName).value[0]
$DestContext = New-AzureStorageContext -StorageAccountName $StorageName `
									   -StorageAccountKey $StorageKey
# skapa container (steg 2)
$ContainerName = "namnge_container"
New-AzureStorageContainer -Name $ContainerName -Context $DestContext


###### Förberedelsen klart #######################################
###################################################################
###################################################################

# Skapa kluster
# Låt användaren skapa login och lösenord för kluster (http och ssh)
Write-Host "password must be 6-72 characters long and must contain at least one digit, one upper case
letter and one lower case letter." -ForegroundColor Red

$HttpCred = Get-Credential -Message "Enter cluster login credentials"

Write-Host "username 'admin' is NOT allowed" -ForegroundColor Red
$SshCred  = Get-Credential -Message "Enter SSH login credentials"


Write-Host "creating cluster..."
$ClusterName = "namnge_klusternamn"
$ClusterType = "välj_typ"
$ClusterSize = 10
New-AzureRmHDInsightCluster -ClusterName $ClusterName `
							-ClusterType $ClusterType `
							-OSType Linux `
							-ResourceGroupName $ResourceName `
							-HttpCredential $HttpCred `
							-SshCredential $SshCred -Location $Location `
							-DefaultStorageAccountName "$StorageName.blob.core.windows.net" `
							-DefaultStorageAccountKey $StorageKey `
							-DefaultStorageContainer $ContainerName `
							-ClusterSizeInNodes $ClusterSize `
							-HeadNodeSize "Standard_D3" `
							-WorkerNodeSize "Standard_D3"