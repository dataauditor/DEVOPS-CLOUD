
Write-Host "Running uninstall script"

$LogSource  = "NBIM"
$Status     = 371
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing uninstall of nbim-puppet")
$Package = Get-Package | ? Name -Match "Puppet Agent"
$output = msiexec /qn /x ($Package.FastPackageReference) | Out-String

# Check that the package has actually been removed
$Package = Get-Package | ? Name -Match "Puppet Agent"
if ( $Package ) {
  Write-Host "Package was NOT removed"
  exit 1
} else {
  $progdata = '/programdata/puppetlabs'
  Write-Host "Cleaning up ${progdata}"
  Remove-Item -Recurse "${progdata}"
}

Write-Host "Finished uninstall"
