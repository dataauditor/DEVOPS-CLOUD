#
# This will be run under install and upgrade
#
# Log Status
#   770: Install and all is OK
#   771: Upgrade and all is OK

Write-Host "Running Connector install script for Citrix"

$SSMClientID = "/ctxxenapptrd/ClientID"
$SSMClientSecret = "/ctxxenapptrd/ClientSecret"
$SSMResourceLocationID = "/ctxxenapptrd/ResourceLocationID"
$SetupFile = "cwcconnector"
$SSMCustomer = "/ctxxenapptrd/Customer"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-ctxconnector")

$RootDir            = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir         = "${RootDir}"+"\Sources"

$InstallFile = (gci $SourcesDir | ? name -match "$SetupFile" | ? extension -match ".exe" | select -first 1).FullName

# check if domain join has been completed
# PartOfDomain (boolean Property)
If ( ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain -eq $false) -and ((Get-WmiObject -Class Win32_ComputerSystem).Workgroup -ne "") )
{
    # we are not joined, exit this script and wait for the next reboot
    Write-Output "The machine is not joined to a domain. The installation cannot continue.."
    Exit
} else {
    Write-Output "Machine is domain joined. Checking for a domain network connection..."
    If (!(Get-NetConnectionProfile | Where-Object {$_.NetworkCategory -eq "Domain"} ))
    {
        # we are in a domain, but not connected to any domain network
        Write-Output "The machine is not connected to any domain network; installation cannot continue.."
        Exit
    } else {
        Write-Output "The machine is connected to domain network; installation will now continue..."
    }
}

#Disable ES
Write-Host -ForegroundColor White "- Disabling IE Enhanced Security "
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name isinstalled -Value 0 #Admin key
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name isinstalled -Value 0 #User Key

#Install Cloud Connector
$ClientID = (Get-SSMParameterValue -Names $SSMClientID -WithDecryption $True).Parameters[0].Value
$ClientSecret = (Get-SSMParameterValue -Names $SSMClientSecret -WithDecryption $True).Parameters[0].Value
$ResourceLocationID = (Get-SSMParameterValue -Names $SSMResourceLocationID -WithDecryption $True).Parameters[0].Value
$Customer = (Get-SSMParameterValue -Names $SSMCustomer -WithDecryption $True).Parameters[0].Value

$InstArgument = "/q /Customer:$Customer /ClientID:$ClientID /ClientSecret:$ClientSecret /ResourceLocationID:$ResourceLocationID /AcceptTermsOfService:true"
Write-Host "Starting installation of connector"
Start-Process $InstallFile -ArgumentList $InstArgument -Wait -NoNewWindow