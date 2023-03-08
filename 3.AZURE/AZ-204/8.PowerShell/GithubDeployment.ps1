#Degiskenler tanimlanir. Mevcut calisanlar tekrar olusturulmaz.
$ResourceGroupName="powershell-grp"
#$Location="North Europe"
#$AppServicePlanName="companyplan211"
$WebAppName="companyapp909311"

#Azure hesabina baglanilir. 
Connect-AzAccount 

#GitHub account'a manual baglanti kurulur.
$Properties=@{
    repoUrl="https://github.com/dataauditor/java-tomcat-sample";
    branch="main";
    isManualIntegration="true";
} 

#Deploy Github Repo to Existing Web App:
Set-AzResource -ResourceGroupName $ResourceGroupName -Properties $Properties `
-ResourceType Microsoft.Web/sites/sourcecontrols `
-ResourceName $WebAppName/web -ApiVersion 2015-08-01 -Force 

