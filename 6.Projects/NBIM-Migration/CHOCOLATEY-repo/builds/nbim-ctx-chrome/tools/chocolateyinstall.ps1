#
# This will be run under install and upgrade Git Client
#
# Log Status
#   750: Install failed. No installer found
#   770: Install and all is OK
#   771: Upgrade and all is OK

$Archive        = "GoogleChromeEnterpriseBundle64"
$Destination    = "C:\Programs\Chrome\"

Write-Host "Running install script of nbim-ctx-chrome"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
$output     = Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-ctx-chrome")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"

$ZipFile = (gci $SourcesDir | ? name -match $Archive | ? extension -like '.zip' | select -first 1).FullName
Expand-Archive -path $ZipFile -destinationpath $Destination

Try
{
    Write-Output "Installing Chrome"
    Start-Process msiexec.exe -Wait -ArgumentList '/I C:\Programs\Chrome\Installers\GoogleChromeStandaloneEnterprise64.msi /norestart'
    Write-Output "Installed Chrome"
} Catch {
    Write-Output "failed to install Chrome"
    Write-Output $_.Exception.Message
    exit 1
}

Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Finished installing nbim-ctx-chrome")