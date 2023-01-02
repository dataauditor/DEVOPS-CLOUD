#
# This will be run under install and upgrade
#
# Log Status
#   770: Install and all is OK
#   771: Upgrade and all is OK

Write-Host "Running install script for Support tools"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-supporttools")

$RootDir            = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir         = "${RootDir}"+"\Sources"
$SupportDir         = "${SourcesDir}"+"\Support"
$SupportDir2010     = "${SupportDir}"+"\VcRedist_2010"
$SupportDir2013     = "${SupportDir}"+"\VcRedist_2013_RTM"
$SupportDir2015     = "${SupportDir}"+"\VcRedist_2015"
$VcRedistVersion    = "vcredist_x64"
$DotNetVersion      = "NDP471-KB4033342-x86-x64-AllOS-ENU"

$ZipFile = (gci $SourcesDir | ? name -match "Support" | ? extension -match ".zip" | select -first 1).FullName
Expand-Archive -path $ZipFile -destinationpath $SourcesDir

$Vcredist2010InstallFile = (gci $SupportDir2010 | ? name -match $VcRedistVersion | ? extension -match ".exe" | select -first 1).FullName

$Vcredist2013InstallFile = (gci $SupportDir2013 | ? name -match $VcRedistVersion | ? extension -match ".exe" | select -first 1).FullName

$Vcredist2015InstallFile = (gci $SupportDir2015 | ? name -match $VcRedistVersion | ? extension -match ".exe" | select -first 1).FullName

$DotNetInstallFile = (gci $SupportDir | ? name -match $DotNetVersion | ? extension -match ".exe" | select -first 1).FullName

Write-Host -ForegroundColor White "Disabling IE Enhanced Security"
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name isinstalled -Value 0 #AdminKey
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name isinstalled -Value 0 #UserKey

if ( $Vcredist2010InstallFile ) {
    Write-Host "Installing Visual C++ 2010"
    $output = Start-Process $Vcredist2010InstallFile -ArgumentList "/Q" -Wait
    Write-Host $output
}

if ( $Vcredist2013InstallFile ) {
    Write-Host "Installing Visual C++ 2013"
    $output = Start-Process $Vcredist2013InstallFile -ArgumentList "/Q" -Wait
    Write-Host $output
}

if ( $Vcredist2015InstallFile ) {
    Write-Host "Installing Visual C++ 2015"
    $output = Start-Process $Vcredist2015InstallFile -ArgumentList "/Q" -Wait
    Write-Host $output
}

if ( $DotNetInstallFile ) {
    Write-Host "Installing .Net for Citrix VDA setup.."
    $output = Start-Process $DotNetInstallFile -ArgumentList "/norestart","/quiet","/q:a" -Wait
    Write-Host $output
}


Write-Host "Installing Roles and Features" -ForegroundColor Green

# Windows Feature XPS Viewer
Write-Host "Installing XPS-Viewer" -ForegroundColor DarkGreen
Add-WindowsFeature XPS-Viewer

# Windows Feature Windows Search Service
Write-Host "Installing Search-Service" -ForegroundColor DarkGreen
Add-WindowsFeature Search-Service

# Check Printer Spooler
Write-Host "Setting up Spooler" -ForegroundColor DarkGreen
set-service -Name "Spooler" -StartupType Automatic -PassThru | Start-service

#Disable UAC for app install
Write-Host "Disabling UAC for App Install" -ForegroundColor DarkGreen
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 0