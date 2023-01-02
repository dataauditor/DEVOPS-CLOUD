Write-Host "Running install script"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-applocker")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$InstallFile = (gci $SourcesDir | ? name -match "applocker.*$" | ? extension -match ".zip" | select -first 1).FullName
if ( $InstallFile ) {
  echo $InstallFile
} else {
  Write-Host "No Installation file found. Looking for .msi inside ${SourcesDir}"
}


#
# User changeable variables
#
$packageName = "AppLocker"
$scriptRoot = "C:\Windows\Temp\applocker"
$windowstemp = "C:\Windows\Temp"

#
# Start logging
#

if (!( Test-Path "$scriptRoot")) {
  New-item -ItemType Directory -Path "$scriptRoot"
   }
Start-Transcript -Path "$scriptRoot\apply-applocker.log"  -Append 



#
# Check if AppLocker already run
#
if($([System.Environment]::GetEnvironmentVariable("STATUS_APPLOCKER","Machine")) -eq "COMPLETE"){
    exit
}else{
    Write-Information "AppLocker not already run! Running..."
    [System.Environment]::SetEnvironmentVariable("STATUS_APPLOCKER","PENDING","Machine")
}


#
# Unarchive Applocker scripts 
#

Copy-Item -Path  $SourcesDir\applocker.zip  -Destination "$windowstemp\applocker.zip"

Expand-Archive -Path "$windowstemp\applocker.zip" -DestinationPath $windowstemp -Force

#Creating polices for system based on scanning then waiting for 20 seconds to allow policies to generate
& "$scriptRoot\Create-Policies.ps1" 
Write-Output "Waiting 30 seconds for scanning to generate rules.."
sleep 30

#Configures Application Identity Service
& "$scriptRoot\LocalConfiguration\ConfigureForAppLocker.ps1"
sleep 5

#Applies AppLocker Rules to Local Policy in enforced mode
& "$scriptRoot\LocalConfiguration\ApplyPolicyToLocalGPO.ps1"



#
# Create flag 
#
[System.Environment]::SetEnvironmentVariable("STATUS_APPLOCKER","COMPLETE","Machine")

Stop-Transcript