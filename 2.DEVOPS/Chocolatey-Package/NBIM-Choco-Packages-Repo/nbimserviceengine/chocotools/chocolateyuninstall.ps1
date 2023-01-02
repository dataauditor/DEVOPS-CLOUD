# Do uninstall

$LogSource      = "NBIM"
$RandomString   = Get-Random -Minimum 100000 -Maximum 999999
$LogPrefix      = "Choco[${RandomString}] REMOVE "

# Must run commands with fully qualified paths
$RootDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FilesDir       = "${RootDir}/../Files"
$DestDir        = "c:/windows/system32"

# Assume the servicename from the .exe (and .ps1) in the files directory
Try {
    $ServiceName = (Get-Item "${FilesDir}/*.exe" | Select-Object -First 1).BaseName
    # Write an eventlog
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 100 -Message ("${LogPrefix} [INFO] Performing uninstall of of ${ServiceName}")
} Catch {
    $msg = $Error[0]
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 301 -Message ("${LogPrefix} [ERR] ${msg}")
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 301 -Message ("${LogPrefix} [ERR] Error when detecting Servicename. Ensure .exe file exists in package.")
}
  
if ( ($ServiceName.Length -ge 64) -Or ($ServiceName -NotMatch "^[a-zA-Z0-9-_]+$" )) {
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 415 -Message ("${LogPrefix} [ERR] Service [${ServiceName}] is not compliant. Must support regex ^[a-zA-Z0-9-_]+$ ")
    exit (151)
}

# Stop the service if it is running
Get-Service -ErrorAction SilentlyContinue "${ServiceName}" | Stop-Service -ErrorAction SilentlyContinue

# Detect any rogue processes, remove the Service and instruct the user to please reboot
$ProcessId = (Get-ItemProperty -ErrorAction SilentlyContinue HKLM:\Software\NBIM\NBIMServices\${ServiceName}   -Name ProcessId).ProcessId
if ( $ProcessId ) {
    Get-Process -Id $ProcessId | Where-Object ProcessName -Match "^powershell$" | Stop-Process -Force
}

# Delete the wrapper and service script
Remove-Item -Force -ErrorAction SilentlyContinue "${DestDir}/${ServiceName}.ps1"
Remove-Item -Force -ErrorAction SilentlyContinue "${DestDir}/${ServiceName}.exe"
Remove-Item -Force -ErrorAction SilentlyContinue "${DestDir}/${ServiceName}-wrapper.ps1"

# Remove the Service Registry Key
# We have to be explicit here because the object is wierd
if ( Get-Item -ErrorAction SilentlyContinue "HKLM:\system\CurrentControlSet\Services\${ServiceName}" ) {
    Get-Item -ErrorAction SilentlyContinue "HKLM:\system\CurrentControlSet\Services\${ServiceName}" | Remove-Item -Force 
}
Write-EventLog -LogName Application -Source ${LogSource} -EventId 100 -Message ("${LogPrefix} [INFO] Service [${ServiceName}] has been removed. Reboot required!")
Write-Host "[WARNING] Remember to reboot!"
