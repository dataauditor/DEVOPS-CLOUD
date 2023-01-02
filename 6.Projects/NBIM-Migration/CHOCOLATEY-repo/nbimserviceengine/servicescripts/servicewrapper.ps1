# EventIds
#   44  : New service created
#   54  : Failed to create service
#   404 : Service not found or name is malformed
#   405 : Could not stop service (Process not found)

# Core variables
$LogSource          = "NBIM"
$RegCore            =  "HKLM:/Software/NBIM"
$RegApp             = "${RegCore}/NBIMServices"
$ServiceNameFlag    = "-ServiceName"
$BaseInstallDir     = "c:/windows/system32"
$ServicePrefix      = "nbim-service-"

# Get the servicename. 
# If the servicename doesn't exist or is malformed, we must exit with some failure
if ("${ServiceNameFlag}" -in $args) {
    # ServiceName must be the next in the array of parameters
    Try {
      $ServiceName = $args[$args.IndexOf("${ServiceNameFlag}") +1]
      "Found ServiceName ${ServiceName}" 
    } Catch {
        Write-EventLog -LogName Application -Source $LogSource -EventId 404 -Message "ServiceName does not exist as argument"
        Exit(404)
    }
    if ($ServiceName -NotMatch "^[A-Za-z0-9-_]*$") {
        Write-EventLog -LogName Application -Source $LogSource -EventId 404 -Message "ServiceName can only contain normal characters, numbers, hyphens and underscore. Found [${ServiceName}]"
        Exit(403)
    }
}

$ScriptFile = "${BaseInstallDir}/${ServicePrefix}${servicename}.ps1"                      # <--- This will be the input script from the user
                                                                          #      and MUST contain -Start switch
                                                                          #      can contain -Stop and -RunBeforeStop switches

#
# These parameters can exist in the users scriptfile. 
# The code in -Start will run during start
# The code in -Stop will run after the service process has terminated
# The code in -RunBeforeStop will run before the service process terminates
$ParamStart         = (Get-Command $ScriptFile | select *  ).Parameters.Values | ? Name -eq "Start"
$ParamStop          = (Get-Command $ScriptFile | select *  ).Parameters.Values | ? Name -eq "Stop"
$ParamRunBeforeStop = (Get-Command $ScriptFile | select *  ).Parameters.Values | ? Name -eq "RunBeforeStop"

# Finalise the service registry
# The registry will contain process ID to allow for easy clean-up 
# during service stopping or restarts
$RegService = "${RegApp}/${ServiceName}"

# Prepwork to build the Registry Hives
"${RegCore}", "${RegApp}", "${RegService}" | % {
  if (-Not (Get-Item $_)) { 
      Try {
          New-Item $_
          $logmsg = "Creating new Registry key for service: ${_}"
          $logid  = 44
      } Catch {
          $logmsg = "Failed to create new registry key for service"
          $logid  = 54
      } 
      Write-EventLog -LogName Application -Source $LogSource -EventId $logid -Message $logmsg
  }
}

# The service engine will send parameters as arguments
# Check to see if any known arguments are sent
if ("-SCMStart" -in $args) {

    # Check to see if -Start flag exists in script, else fail
    if ($ParamStart.ParameterType.Name -ne "SwitchParameter") {
        Write-EventLog -LogName Application -Source $LogSource -EventId 401 -Message "Cannot start service. -Start param not found in Service Script."
        exit(401)
    }

    # Check if ProcessId exist and is running
    $possiblepid = (Get-ItemProperty -ErrorAction SilentlyContinue $RegService).ProcessId
    if ($possiblepid -gt 0) {
        if ((Get-Process -id $possiblepid -ErrorAction SilentlyContinue).ProcessName -Match "^powershell$") {
            # Process is already running
            Write-Host "Service is already running."
            exit(406)
        } else {
            # ProcessId exists in registry, but the process isn't running. Clean up
            Remove-ItemProperty $RegService -Name "ProcessId"
        }
    }

    # Start the user's service process
    # Get the process ID and service ID and store it in registry 
    $newproc = Start-Process $PSHOME\powershell.exe -PassThru -ArgumentList "-WindowStyle Hidden -Command  &'${ScriptFile}' -Start"  
    New-ItemProperty $RegService -Name "ProcessId" -Value $newproc.id
} elseif ("-SCMStop" -in $args)  {
    # Run any STOP scripts from the service exists ( and it is of type Switch)

    if ($ParamRunBeforeStop.ParameterType.Name -eq "SwitchParameter") {
        # -RunBeforeStop parameter exists AND it is of type Switch
        # This should call a command to be run before the script is terminated completely
        Invoke-Expression -Command "${ScriptFile} -RunBeforeStop"
    }

    $CheckPid = (Get-ItemProperty  $RegService).ProcessId
    $proc = Get-Process -Id ((Get-ItemProperty  $RegService).ProcessId)
    if ($proc.ProcessName -Match "^PowerShell$") {
        # This is the process. Kill it
        $proc | Stop-Process -Force
        # Be a good lad and wait until the process has completely died
        $counter  = 0
        $maxcount = 10
        $sleep    = 1
        $KillSuccessful = $False
        While ($counter -lt $maxcount) {
            if ( -Not (Get-Process -Id $proc.Id )) {
                # Process is dead. Clean up in registry!
                $counter = $maxcount
                $KillSuccessful = $True
                Remove-ItemProperty $RegService -Name ProcessId
            }
            Sleep $sleep
            $counter = $counter +1
        }
        if ($KillSuccessful) {
            if ($ParamStop.ParameterType.Name -eq "SwitchParameter") {
                # -Stop parameter exists AND it is of type Switch
                # This should call a command to be run after the service has been properly terminated
                Invoke-Expression -Command "${ScriptFile} -Stop"
            }
        }
    } else {
        Write-EventLog -LogName Application -Source $LogSource -EventId 405 -Message "Could not stop service process [${ServiceName}] because process was not found."
        exit(405)
    }
    Return
}
Return 
