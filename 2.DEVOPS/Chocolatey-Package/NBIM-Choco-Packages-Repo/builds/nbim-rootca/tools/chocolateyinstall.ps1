Write-Host "Running install script"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-rootca")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$InstallFile = (gci $SourcesDir | ? name -match "cert.*$" | ? extension -match ".der" | select -first 1).FullName

Write-Host "Importing new Cert.... $InstallFile  "

#Checking if the cert already exists 
if (!((Get-ChildItem -path Cert:\LocalMachine\Root).subject -contains "CN=NBIM Internal Root CA 02 G1, O=NBIM, C=NO")){
#Import Certificate to the cert store
Write-Host "Adding new Cert.... $  "
Import-Certificate -FilePath "$InstallFile" -CertStoreLocation Cert:\LocalMachine\Root

}

#Checking for successful import
if ((Get-ChildItem -path Cert:\LocalMachine\Root).subject -contains "CN=NBIM Internal Root CA 02 G1, O=NBIM, C=NO")
  {
  Write-host "Successfully Added Root CA certificate"
  }
  else 
  {
  Write-host "Failed to add the Root CA certificate"
  }