# Do Modify

$LogSource      = "NBIM"
$RandomString   = Get-Random -Minimum 100000 -Maximum 999999
$LogPrefix      = "Choco[${RandomString}] MODIFY "

# Must run commands with fully qualified paths
$RootDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FilesDir       = "${RootDir}/../Files"
$DestDir        = "c:/windows/system32"

# Assume the servicename from the .exe (and .ps1) in the files directory
Try {
    $ServiceName = (Get-Item "${FilesDir}/*.exe" | Select-Object -First 1).BaseName
    # Write an eventlog
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 100 -Message ("${LogPrefix} [INFO] Performing uninstall of ${ServiceName}")
} Catch {
      $msg = $Error[0]
      Write-EventLog -LogName Application -Source ${LogSource} -EventId 301 -Message ("${LogPrefix} [ERR] ${msg}")
      Write-EventLog -LogName Application -Source ${LogSource} -EventId 301 -Message ("${LogPrefix} [ERR] Error when detecting Servicename. Ensure .exe file exists in package.")
}

Write-EventLog -LogName Application -Source ${LogSource} -EventId 100 -Message ("${LogPrefix} [INFO] Performing MODIFY of of ${ServiceName}")