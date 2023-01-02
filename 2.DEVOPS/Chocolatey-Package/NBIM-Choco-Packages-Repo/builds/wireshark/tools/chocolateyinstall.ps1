#
# This will be run under install and upgrade
#
#
# Log Status
#   750: Install failed. No installer found
#   770: Install and all is OK
#   771: Upgrade and all is OK

$Version    = "3.4.7"
$Installer  = "Wireshark-win64-${Version}.exe"
$Rand       = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Running install script"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of Wireshark")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$InstallFile = (gci $SourcesDir | ? name -like "${Installer}" | select -first 1).FullName

if ( $InstallFile ) {
    $output = Invoke-Expression '& "${InstallFile}" /S /norestart  '
    Write-Host $output
    $Status = 770
    $msg = "Install of ${InstallFile} finished"
  } else {
    $Status = 750
    $msg = "Could not install. No Installation file found. Looking for installer ${Installer} inside ${SourcesDir}"
  }

  Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${Rand} Chocolatey: ${msg}")