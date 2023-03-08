#Degiskenler tanimlanir. Mevcut calisanlar tekrar olusturulmaz.
$ResourceGroupName="powershell-grp"
#$Location="North Europe"
$AppServicePlanName="companyplan211"
$WebAppName="companyapp909311"
$SlotName="Staging"
$TargetSlot="production"


#Azure hesabina baglanilir. 
Connect-AzAccount 

#Change AppServicePlan to Standard:
Set-AzAppServicePlan -Name $AppServicePlanName -ResourceGroupName $ResourceGroupName `
-Tier Standard 

#Staging Slot Olusturulur:
New-AzWebAppSlot -Name $WebAppName -ResourceGroupName $ResourceGroupName `
-Slot $SlotName

#GitHub account'a manual baglanti kurulur.
$Properties=@{
    repoUrl="https://github.com/dataauditor/java-tomcat-sample";
    branch="main";
    isManualIntegration="true";
} 

#Deploy Github Repo to Existing Web App:
Set-AzResource -ResourceGroupName $ResourceGroupName -Properties $Properties `
-ResourceType Microsoft.Web/sites/slots/sourcecontrols `
-ResourceName $WebAppName/$SlotName/web -ApiVersion 2015-08-01 -Force 

#Slot'lar arasinda gecis yapma:
Switch-AzWebAppSlot -Name $WebAppName -ResourceGroupName $ResourceGroupName `
-SourceSlotName $SlotName -DestinationSlotName $TargetSlot 