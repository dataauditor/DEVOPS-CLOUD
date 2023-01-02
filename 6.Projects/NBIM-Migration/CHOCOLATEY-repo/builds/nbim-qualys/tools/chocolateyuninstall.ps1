# Removal of splunk universal forwarder
$LogSource  = "NBIM"
$Status     = 371
$PackageName = "Qualys"

Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing uninstall of of ${PackageName}")
$arg_qualys = "Uninstall=TRUE"
$UninstallFile = "C:\Program Files\Qualys\QualysAgent\Uninstall.exe"

Write-Host "Stopping all services related to Qualys .."
Get-Service -Include "*qualys*" | Stop-Service -Force

Try
 {
    Write-Output "Trying to uninstall Qualys now.."
    Write-Host $arg_qualys
    $p=Start-Process $UninstallFile $arg_qualys -NoNewWindow -Wait | Out-String
 }
 Catch
 { 
     Write-Output "Oops.. failed to uninstall Qualys"
     Write-Output $_.Exception.Message
     exit 1
 }

 Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Uninstalled Qualys")