#
# This will be run under install and upgrade Git Client
#
# Log Status
#   750: Install failed. No installer found
#   770: Install and all is OK
#   771: Upgrade and all is OK

$Installer  = "Python-*-amd64.exe"
$Rand       = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Running install script of ${Installer}"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
$output     = Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${Rand} Chocolatey: Performing install of of ${Installer}")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$InstallFile = (gci $SourcesDir | ? name -like "${Installer}" | ? extension -like '.exe' | select -first 1).FullName
$InstallArgs = "/passive PrependPath=1 InstallAllUsers=1" # DefaultAllUsersTargetDir=c:\Python\310 /log c:\Python310\installer-logs\installer.log

if (-not $InstallFile ) {
	$Status = 750
	$msg = "Could not install. No Installation file found. Looking for installer ${Installer} inside ${SourcesDir}"
	Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${Rand} Chocolatey: ${msg}")
	return $Status
}
echo $InstallFile

#Get package parameters if any
$pp = Get-PackageParameters

Write-Host $pp["targetDir"]

if ($pp["targetDir"]) {
    Write-Host "Found targetDir in parameter input"
    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Found parameters in the input...")
	$targetDir = ([System.IO.DirectoryInfo]$pp["targetDir"]).FullName
	
	# add TargetDir to list of installer-arguments
	$InstallArgs = $InstallArgs + " DefaultAllUsersTargetDir=${targetDir}"
}

$msg = "Installing with argumentlist: ${InstallArgs}"
Write-Host $msg 
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: ${$msg}")

$installProcess = Start-Process -Wait -PassThru -FilePath $InstallFile -ArgumentList $InstallArgs
$Status = 770
$msg = "Install of ${InstallFile} finished"


Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${Rand} Chocolatey: ${msg}")
