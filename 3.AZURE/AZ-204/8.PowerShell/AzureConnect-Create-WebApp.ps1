#Degiskenler tanimlanir.
$ResourceGroupName="powershell-grp"
$Location="North Europe"
$AppServicePlanName="companyplan211"
$WebAppName="companyapp909311"

#Azure hesabina baglanilir.
Connect-AzAccount 

#RG olusturulur.
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

#AppServicePlan olusturulur.
New-AzAppServicePlan -ResourceGroupName $ResourceGroupName `
-Location $Location -Tier "B1" -NumberofWorkers 1 -Name $AppServicePlanName

#Web App'i olusturma.
New-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName `
-Location $Location -AppServicePlan $AppServicePlanName 