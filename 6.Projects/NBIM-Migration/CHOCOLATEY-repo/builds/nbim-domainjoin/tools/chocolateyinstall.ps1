# Default variables
$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$WindowsTemp = "C:\Windows\Temp"

# Think: Should we domainjoin a server that's already in the domain?
# This script will do that - and re-join during any upgrade process

# Firstly we need to install some helper add-ons to run commands towards the domain
# Typically "set-"
Install-WindowsFeature RSAT-AD-Tools

# Wrap the domainjoin logic into a multi-test layer
# If the first domainjoin fails, try and try again before quiting
$outerretry     = 0
$maxouterretry  = 3
do {
  $output     = "ToBeRun"
  $retry      = 0
  $retries    = 30
  $waittime   = 5
  do {
    if ($output.Contains('already in progress')) {
      $retry += 1
      Write-host "Puppet is already running. Waiting for ${waittime}s. Retry: ${retry}/${retries})"
      Start-Sleep -Seconds $waittime
    }
  
    if ( $retry -eq 0 ) {
      # Only print this information on the first run
      Write-Host "Attempting Domainjoin process..."
    }
    # Ensure we rename the computer during domainjoin if a previous rename action has been taken
    # and the machine is not rebooted
    $newhostname = (get-itemProperty -ErrorAction SilentlyContinue HKLM:\system\CurrentControlSet\control\ComputerName\ComputerName).ComputerName
    $oldhostname = (get-itemProperty -ErrorAction SilentlyContinue HKLM:\system\CurrentControlSet\control\ComputerName\ActiveComputerName).ComputerName
    if ( $newhostname -ne $oldhostname ) {    
      if ( $retry -eq 0 ) {
        # Only print this information on the first run
        Write-Host "Detected new hostname [${newhostname}] as part of domainjoin action"
      }
      $output = Invoke-Command { Set-Item Env:FACTER_domainjoin -Value 'true'; Set-Item Env:FACTER_domainjoinrename -Value $newhostname; puppet agent -t }
    } else {
      $output = Invoke-Command { Set-Item Env:FACTER_domainjoin -Value 'true'; puppet agent -t }
    }
    Write-Host "Output from Add-Computer: ${output}"
    
  } while ( ($output.Contains('already in progress') -And ($retry -lt $retries) ))  
  if ((Get-ComputerInfo).csdomain -Like "WORKGROUP") {
    # Domain Join is still not complete. Try again
    Write-host "Trying another round. Retry: ${outerretry}/${maxouterretry})"
    Start-Sleep -Seconds $waittime
    $outerretry += 1
  } else {
    $outerretry = $maxouterretry
  }
} while ( $outerretry -lt $outerretries )



# Logic to check that domain join was successful
$d = (Get-ComputerInfo).csdomain
if ( $d -Like "WORKGROUP") { 
  Write-Host "Domain join process failed"
  if ($retry -ge $retries) {
    write-error "Puppet seems stuck running. Check logs in puppet."
  }
  exit 55
} else {
  Write-Host "Computer is now part of domain: ${d}" 
  Write-Host -ForegroundColor CYAN "You should REBOOT to complete the domainjoin process"
  Write-Host "  "  # Just an empty linebreak in the output to make it pop
}
