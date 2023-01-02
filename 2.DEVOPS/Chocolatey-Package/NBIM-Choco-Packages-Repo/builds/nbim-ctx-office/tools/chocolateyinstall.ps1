#
# This will be run under install and upgrade Git Client
#
# Log Status
#   750: Install failed. No installer found
#   770: Install and all is OK
#   771: Upgrade and all is OK

$DeploymentTool = "officedeploymenttool_15028-20160"
$config = "Configuration"
$microsoftURL = "www.microsoft.com"

Write-Host "Checking connectivity to Microsoft Office servers.."

$result = Test-NetConnection $microsoftURL -Port 443 | ? TcpTestSucceeded -match "True" | select TcpTestSucceeded

if ($result -eq $null) {
    Write-Host "Microsoft servers need to be whitelisted to download and configure Office components. The package will now exit.."
    Exit 
}
Write-Host "Running install script of nbim-ctx-office"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
$output     = Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-ctx-office")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"

$InstallFile = (gci $SourcesDir | ? name -match $DeploymentTool | ? extension -like '.exe' | select -first 1).FullName
$ConfigFile = (gci $SourcesDir | ? name -match $config | ? extension -like '.xml' | select -first 1).FullName

Try
{
    Write-Output "Installing office"
    Start-Process $InstallFile -ArgumentList '/extract:C:\ /quiet'
    Write-Output $ConfigFile
    Copy-Item -Force "${ConfigFile}" -Destination "C:\"
    Start-Sleep -Seconds 30
    $setupfile = "C:\setup.exe"
    Start-Process $setupfile -ArgumentList '/configure C:\Configuration.xml' -Wait
    Write-Output "Installed office"
} Catch {
    Write-Output "failed to install office"
    Write-Output $_.Exception.Message
    exit 1
}

Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Finished installing nbim-ctx-office")