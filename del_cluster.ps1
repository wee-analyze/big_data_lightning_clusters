# stäng ner kluster

Write-Host "deleting cluster..."
$ClusterName = "ange_kluster"
Remove-AzureRmHDInsightCluster -ClusterName $ClusterName