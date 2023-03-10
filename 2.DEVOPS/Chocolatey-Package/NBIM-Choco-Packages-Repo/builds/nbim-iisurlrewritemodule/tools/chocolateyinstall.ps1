#
# This will be run under install and upgrade
#
# This will be run under install and upgrade Git Client
#
# Log Status
#   750: Install failed. No installer found
#   770: Install and all is OK
#   771: Upgrade and all is OK

$Installer  = "iis url rewrite"
$Rand       = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Running install script of ${Installer}"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
$output     = Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${Rand} Chocolatey: Performing install of of ${Installer}")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$InstallFile = (gci $SourcesDir | ? extension -like '.msi' | select -first 1).FullName
if ( $InstallFile ) {
  echo $InstallFile

  Start-Process -FilePath "msiexec.exe" -Args ("/i {0} /qn /norestart" -f $InstallFile) -Wait -PassThru -NoNewWindow
  $Status = 770
  $msg = "Install of ${InstallFile} finished"
} else {
  $Status = 750
  $msg = "Could not install. No Installation file found. Looking for installer ${Installer} inside ${SourcesDir}"
}

Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${Rand} Chocolatey: ${msg}")
Write-Host $msg