# Skapa kluster
# Låt användaren skapa login och lösenord för kluster (http och ssh)
Write-Host "password must be 6-72 characters long and must contain at least one digit, one upper case
letter and one lower case letter." -ForegroundColor Red
$ResourceName = "ange_resource"
$StorageName = "ange_resource"
$StorageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceName `
											-Name $StorageName).value[0]


$HttpCred = Get-Credential -Message "Enter cluster login credentials"


Write-Host "username 'admin' is NOT allowed" -ForegroundColor Red
$SshCred  = Get-Credential -Message "Enter SSH login credentials"


Write-Host "creating cluster..."
$ClusterName = "namnge_kluster"
$ClusterType = "välj_typ"
$ContainerName = "ange_container"
$Location = "North Europe" #locations: Southeast Asia, North Europe, West Europe, East US, or West US
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