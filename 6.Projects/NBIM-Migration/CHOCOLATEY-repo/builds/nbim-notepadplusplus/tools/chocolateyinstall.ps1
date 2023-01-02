#
# This will be run under install and upgrade
# Log Status
#   750: Install failed. No installer found
#   770: Install and all is OK

$Installer  = "npp.*.Installer.x64.exe"
$Rand       = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Running install script"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of Notepad++")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$InstallFile = (gci $SourcesDir | ? name -like "${Installer}" | ? extension -like '.exe' | select -first 1).FullName

if ( $InstallFile ) {
    $installProcess = Start-Process -Wait -PassThru -FilePath $InstallFile -ArgumentList "/S /norestart"
    $Status = 770
    $msg = "Install of ${InstallFile} finished"
  } else {
    $Status = 750
    $msg = "Could not install. No Installation file found. Looking for installer ${Installer} inside ${SourcesDir}"
  }

  Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${Rand} Chocolatey: ${msg}")