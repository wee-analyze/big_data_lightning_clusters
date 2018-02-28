Write-Host "deleting resource group..."

$ResourceGroupName = "ange_resource"
Remove-AzureRmResourceGroup -Name $ResourceGroupName