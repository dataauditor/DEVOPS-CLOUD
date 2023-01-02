# Do install

$LogSource      = "NBIM"
$Status         = 770
$RandomString   = Get-Random -Minimum 100000 -Maximum 999999
$LogPrefix      = "Choco[${RandomString}] INSTALL"

# Must run commands with fully qualified paths
$RootDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FilesDir       = "${RootDir}/../Files"
$DestDir        = "c:/windows/system32"

# We have a service.exe file. Let's get that running as a service and verify the installation
# Get the name of the service from the directory. 
# Make sure it's got a good name.

# Assume the servicename from the .exe (and .ps1) in the files directory
Try {
  $ServiceName = (Get-Item "${FilesDir}/*.exe" | Select-Object -First 1).BaseName
  # Write an eventlog
  Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("${LogPrefix} [INFO] Performing install of of [${ServiceName}]")
  $lcservicename = $ServiceName.ToLower()
} Catch {
    $msg = $Error[0]
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 301 -Message ("${LogPrefix} [ERR] ${msg}")
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 301 -Message ("${LogPrefix} [ERR] Error when detecting Servicename. Ensure .exe file exists in package.")
}

if ( ($ServiceName.Length -ge 64) -Or ($ServiceName -NotMatch "^[a-zA-Z0-9-_]+$" )) {
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 302 -Message ("${LogPrefix} [ERR] Service [${ServiceName}] is not compliant. Must support regex ^[a-zA-Z0-9-_]+$ ")
    exit (151)
}

# We really only want to copy the .exe and .ps1 files, so let's only check for those
$ExeSrc         = "${FilesDir}/${ServiceName}.exe"
$Ps1Src         = "${FilesDir}/${lcservicename}.ps1"
$ExeDst         = "${DestDir}/${ServiceName}.exe"
$Ps1Dst         = "${DestDir}/${lcservicename}.ps1"
$WrpSrc         = "${FilesDir}/${ServiceName}-wrapper.ps1"
$WrpDst         = "${DestDir}/${lcservicename}-wrapper.ps1"

# Copy the service files into their directory
Copy-Item -Force "${ExeSrc}" "${ExeDst}"
Copy-Item -Force "${Ps1Src}" "${Ps1Dst}"
Copy-Item -Force "${WrpSrc}" "${WrpDst}"

# Verify that the files exist in the destination location
if ( (Test-Path -PathType Leaf "${ExeDst}") -And (Test-Path -PathType Leaf "${Ps1Dst}") -And (Test-Path -PathType Leaf "${WrpDst}") ) {
    # Add metadata, description and version
    $Srv = Get-Service -ErrorAction SilentlyContinue "${ServiceName}"
    if ( $Srv ) {
        
        if ( $srv.Status -Like "Running" ) {
            Write-EventLog -LogName Application -Source ${LogSource} -EventId 557 -Message ("${LogPrefix} [INFO] Service [${ServiceName}] is already exists and is running.`nWill update and restart.")
            $Srv | Restart-Service
        } else {
            Write-EventLog -LogName Application -Source ${LogSource} -EventId 558 -Message ("${LogPrefix} [INFO] Service [${ServiceName}] is already exists but is not running.`nService Binaries are updated and ready for service start.")
        }
    } else {
        New-Service -Name $ServiceName -BinaryPathName "${ExeDst}" -StartupType Automatic -DisplayName $ServiceName -Description "${ServiceName} from NBIM Service Builder"
        Write-EventLog -LogName Application -Source ${LogSource} -EventId 550 -Message ("${LogPrefix} [INFO] Registering new service [${ServiceName}]" )
    }
} else {
    $tmp = $Error[0]
    Write-Warning ("Failed to install service ${ServiceName}: Destination files are not in their expected location.")
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 312 -Message ("${LogPrefix} [ERR] Failed to install service [${ServiceName}].`nDestination files are not in their expected location.")
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 312 -Message ("${LogPrefix} [ERR] ${tmp}")
}

# Final verification: Check the service is installed and that it is in registry 
if ( Get-Service -ErrorAction SilentlyContinue "${ServiceName}" ) {
    $msg = "New service [${ServiceName}] available in serviceview"
    Write-EventLog -LogName Application -Source ${LogSource} -EventId 100 -Message ("${LogPrefix} [INFO] $msg" )
    if ( Get-Item -ErrorAction SilentlyContinue "HKLM:\system\CurrentControlSet\Services\${ServiceName}" ) {
        Write-EventLog -LogName Application -Source ${LogSource} -EventId 100 -Message ("${LogPrefix} [INFO] Service is correctly registered" )
    } else {
        $msg = "Service is missing from HKLM registry`nIf you had a previous install, reboot computer and try again"
        Write-EventLog -LogName Application -Source ${LogSource} -EventId 558 -Message ("${LogPrefix} [ERR]  ${msg}" )
        Write-Host $msg
        Write-Host "[ERROR] Install contains errors."
    }
} 

