# Removal of splunk universal forwarder
$LogSource  = "NBIM"
$Status     = 370
$PackageName = "UniversalForwarder"
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing uninstall of of ${PackageName}")

$pck = Get-Package | ? name -match "${PackageName}" 
if ( $pck ) {
    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Package found. Running msiexec uninstall on ${PackageName}")
    msiexec /qn /x $pck.FastPackageReference
} else {
    $Status = 374
    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: No such package found. Cannot uninstall ${PackageName}")
}