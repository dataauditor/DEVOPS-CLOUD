#
# This will be run under install and upgrade
#
# Log Status
#   770: Install and all is OK
#   771: Upgrade and all is OK

Write-Host "Running SCD install script for VDA"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-scd")

$RootDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir    = "${RootDir}"+"\Sources"
$SSMpassword   = "/ctxxenapptrd/ctxscdpwd"
$djpasswordssm = (Get-SSMParameterValue -Names $SSMpassword -WithDecryption $True).Parameters[0].Value

#Set environment variable to allow for running of unsigned executable (for SCD)
Write-Warning "Disabling zone checks for SCD Directory service install"
[System.Environment]::SetEnvironmentVariable(
 'SEE_MASK_NOZONECHECKS',
 '1',
 [System.EnvironmentVariableTarget]::Machine
)

$Task_File = "${RootDir}"+"\files" + "\install_SCD.ps1"
$Task_Action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$Task_File`"" 
$Task_SettingsSet = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -Compatibility "Win8" -ExecutionTimeLimit "12:00:00"
$Task_Trigger = New-ScheduledTaskTrigger -AtStartup
$BootstrapTask = New-ScheduledTask -Action $Task_Action -Settings $Task_SettingsSet 
Register-ScheduledTask -TaskName "SCD-Citrix-Install" -Action $Task_Action -Settings $Task_SettingsSet -RunLevel Highest -User "MOAWINDOM\_Servicecitrixmove" -Password $djpassw -Trigger $Task_Trigger