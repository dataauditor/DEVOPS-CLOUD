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
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-puppet")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$InstallFile = (gci $SourcesDir | ? name -match "puppet-.*$" | ? extension -match ".msi" | select -first 1).FullName
if ( $InstallFile ) {
  echo $InstallFile
} else {
  Write-Host "No Installation file found. Looking for .msi inside ${SourcesDir}"
}

Write-Host "Performing installation of new agent..."
# Write output of msiexec into variable to force the script to wait until update is completed before continuing
# Forwarding the msiexec output into a variable to force the script to wait until completion
$output = msiexec /qn /i ${InstallFile} /norestart /l*v $env:ProgramData\chocolatey\puppetlog.log | Out-String

$counter  = 0
$maxcount = 15
$allok    = $False
$PuppetDir  = "/programdata/puppetlabs/puppet"
$PuppetConf = "${PuppetDir}/etc/puppet.conf"
while ( $Counter -lt $maxcount ) {
  if ( Get-Service -ErrorAction SilentlyContinue puppet | ? Status -Match "running"  ) {
    $Counter = $maxcount
    Write-Host "Service is online"
    $allok = $True
  } else {
    Write-Host "Waiting for service to come online..."
    Sleep 3
  }
  $Counter = $Counter + 1
}
if ( ! $allok ) {
  Write-Error "Service failed to come online. Installation failed."
  exit 1
}

# Perforr cleanup and reset 
Remove-Item -ErrorAction SilentlyContinue -Force "${PuppetConf}"
Remove-Item -ErrorAction SilentlyContinue -Force -Recurse "${PuppetDir}/cache"
Write-Output ("[main]")              | Out-File -Encoding ascii -FilePath $PuppetConf
Write-Output ("runinterval=60s")     | Out-File -Encoding ascii -FilePath $PuppetConf -Append
Write-Output ("environment=master")  | Out-File -Encoding ascii -FilePath $PuppetConf -Append
Write-Output ("certname="+(hostname).ToLower()+"_"+(Get-Random -Maximum 9999999 -Minimum 1000000))  | Out-File -Encoding ascii -FilePath $PuppetConf -Append

# All done. Restart agent and do a puppet run
$msg = "Chocolatey: Done installing nbim-puppet"
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ($msg)
