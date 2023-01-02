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
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-splunkforwarder")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$InstallFile = (gci $SourcesDir | ? name -match "splunkforwarder-.*$" | ? extension -match ".msi" | select -first 1).FullName
if ( $InstallFile ) {
  echo $InstallFile
} else {
  Write-Host "No Installation file found. Looking for .msi inside ${SourcesDir}"
}

Write-Host "Performing installation of new agent..."
# Write output of msiexec into variable to force the script to wait until update is completed before continuing

$output = msiexec /qn /i ${InstallFile} /norestart AGREETOLICENSE=yes | Out-String

Write-Host $Output

#
# Ensure that the deploymentclient is installed and available
#

$deploymentfile = "C:\Program Files\SplunkUniversalForwarder\etc\apps\nbim_azure_deploymentclient\local\deploymentclient.conf"
$deploymentpath = Split-Path $deploymentfile
Write-Host $deploymentpath
if ( ! (Get-Item -ErrorAction SilentlyContinue $deploymentpath)) {

  New-Item -Path $deploymentpath -Type Directory
}

cp ${FilesDir}/deploymentclient.conf $deploymentfile

#
# Now that the software is installed, reset the agent
#
$exepath  = "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe"
$output   = (${exepath} + " clean locks")
$output   = (${exepath} + " clone-prep-clear-config")

#
# Redo all the default security config
#
#Change default password
$env:OPENSSL_CONF='C:\Program Files\SplunkUniversalForwarder\openssl.cnf'
$GeneratedText = &'C:\Program Files\SplunkUniversalForwarder\bin\openssl.exe' rand -base64 32
Out-File -FilePath "C:\Program Files\SplunkUniversalForwarder\etc\system\local\user-seed.conf" -InputObject "PASSWORD = $GeneratedText"

#Disable remote access
Add-Content -Path "C:\Program Files\SplunkUniversalForwarder\etc\splunk-launch.conf" -Value "SPLUNK_BINDIP=127.0.0.1"

#Reset Unique Host ID for Splunk    
$msg = "Generate a new Unique Host ID for splunk"
Write-Host $msg
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ($msg)
Remove-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\instance.cfg" -Force -ErrorAction Continue

#Remove access inheritance and read for users
$folder = "C:\Program Files\SplunkUniversalForwarder"
$acl = Get-Acl $folder
$acl.SetAccessRuleProtection($true,$true)
$acl | Set-Acl
$acl = Get-Acl $folder
$acl.Access | where {$_.IdentityReference -eq "BUILTIN\Users"} | foreach { $acl.RemoveAccessRuleSpecific($_) }
$acl | Set-Acl

# All done. Restart agent
Restart-Service splunk*
$msg = "Chocolatey: Done installing nbim-splunkforwarder"
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ($msg)
