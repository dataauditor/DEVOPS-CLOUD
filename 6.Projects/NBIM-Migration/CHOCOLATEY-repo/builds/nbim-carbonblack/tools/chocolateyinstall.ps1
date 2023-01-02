#
# This will be run under install and upgrade
#
#
# Log Status
#   770: Install and all is OK
#   771: Upgrade and all is OK

Write-Host "Running install script"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-carbonblack")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"

$ZipFile = (gci $SourcesDir | ? name -match "CarbonBlack-.*$" | ? extension -match ".zip" | select -first 1).FullName
Expand-Archive -path $ZipFile -destinationpath $SourcesDir

$InstallFile = (gci $SourcesDir | ? name -match "CarbonBlack.*$" | ? extension -match ".exe" | select -first 1).FullName
if ( $InstallFile ) {
  echo $InstallFile
} else {
  Write-Host "No Installation file found. Looking for .exe inside ${SourcesDir}"
}

Write-Host "Performing installation of new agent..."
# Write output of msiexec into variable to force the script to wait until update is completed before continuing

$a = Start-Process -ArgumentList "/S" -Wait -NoNewWindow -filepath $InstallFile
Get-Service -Include "*carbonblack*" | Stop-Service -Force
Get-Service -Include "*carbonblack*" | Set-Service -StartupType Automatic
Get-ChildItem ${env:windir}\CarbonBlack\store\MD5_* -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem ${env:windir}\CarbonBlack\EventLogs\* -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
New-ItemProperty -Path HKLM:\SOFTWARE\CarbonBlack\config -Name SensorId -Value 0 -PropertyType String -Force | Out-Null

# Get-Service -Include "*carbonblack*" | Start-Service

$msg = "Chocolatey: Done installing nbim-carbonblack"
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ($msg)
Write-Warning "CarbonBlack is successfully installed. The computer requires a reboot to finalize the Installation."