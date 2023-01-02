#
# This will be run under install and upgrade
#
# Log Status
#   750: Install failed.
#   770: Install and all is OK
#   771: Upgrade and all is OK

$ProductName = "SQL Server Management Studio"
$Installer  = "SSMS-Setup-ENU"
$Rand       = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Running install script of ${Installer}"

# Write an eventlog
$LogSource  = "NBIM"
$StatusOk   = 770
$StatusFail = 750
$output     = Write-EventLog -LogName Application -Source ${LogSource} -EventId $StatusOk -Message ("${Rand} Chocolatey: Performing install of of ${ProductName}")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"


# Create downloadfolder and prepare filename
New-Item -Path $SourcesDir -ItemType Directory -Force | Out-Null
$InstallFile = Join-Path -Path $SourcesDir -ChildPath 'SSMS-Setup-ENU.exe'
Write-Host "Creating folder [$SourcesDir]"
Write-Host "Prepared downloadpath for setup.exe [$InstallFile]"


# This package requires access to public
try { 
  Write-Host "Testing Netconnection"
  Test-NetConnection 'go.microsoft.com' -Port 443 -ErrorAction Stop | Out-Null
  Write-Host "Netconnection good"
} catch {
  $msg = "This package requires internet access to download the .exe from go.microsoft.com"
  Write-EventLog -LogName Application -Source ${LogSource} -EventId $StatusFail -Message ("${Rand} Chocolatey: Failed install of of ${ProductName}: $msg")
  Write-Host $msg
  throw $msg
}


# 18.12.1 = 'https://go.microsoft.com/fwlink/?linkid=2199013' MD5 = 40658CD21A76C2BB225815CCAC86FF14
# Starting with SSMS 18.7, SSMS installs Azure Data Studio by default: skipped by installing with command line flag 'DoNotInstallAzureDataStudio=1'

try {
  Write-Host "About to download setup.exe, please wait"
  $ErrorActionPreference = 'Stop'
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest -UseBasicParsing -Uri 'https://go.microsoft.com/fwlink/?linkid=2199013' -OutFile $InstallFile
} catch {
  $msg = "Failed to download the .exe from go.microsoft.com"
  Write-EventLog -LogName Application -Source ${LogSource} -EventId $StatusFail -Message ("${Rand} Chocolatey: Failed install of of ${ProductName}: $msg")
  Write-Host $msg
  throw $msg
}


# Verify filehash of downloaded file
$downloadhash = (Get-FileHash -Algorithm MD5 -Path $InstallFile).Hash 
$hashMatches = $downloadhash -eq '40658CD21A76C2BB225815CCAC86FF14'

if (-not $hashMatches) {
  $msg = ("MD5 filehash for the downloaded file did not match, downloaded file had filehash [{0}]" -f $downloadhash)
  Write-EventLog -LogName Application -Source ${LogSource} -EventId $StatusFail -Message ("${Rand} Chocolatey: Failed install of of ${ProductName}: $msg")
  Write-Host $msg
  throw $msg
}

Write-Host "Filehash OK, starting installation..."

# Start installation
Start-Process $InstallFile -ArgumentList '/quiet /norestart DoNotInstallAzureDataStudio=1' -Wait -NoNewWindow # /log <logfile prefix> # default $TEMP%\SSMSSetup for logs
Remove-Item -Force -Path $InstallFile

# All done.
$msg = "Done installing"
Write-EventLog -LogName Application -Source ${LogSource} -EventId $StatusOk -Message ("${Rand} Chocolatey: ${msg}")
Write-Host $msg