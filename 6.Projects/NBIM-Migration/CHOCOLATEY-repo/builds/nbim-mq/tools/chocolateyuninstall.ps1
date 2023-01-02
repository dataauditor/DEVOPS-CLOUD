# Extract all installed software and get it removed

# Find the object from the package collection
$SearchString = "IBM MQ"
$p = Get-Package -Provider Programs -IncludeWindowsInstaller | ?  name -match "${SearchString}"

# Extract the uninstall command from the package metadata
$Uninstall = "QuietUninstallString"
$cmd = (((((($p.swidtagtext) -split "\n" | Select-String "${Uninstall}" ) -Replace ".*${Uninstall}=", "" ) -Replace "&quot;", "" ) -Replace '^"', "'" ) -Replace ".exe ", ".exe' " ).Trim() -Replace '"', ''

# Perform the uninstall
Invoke-Expression "& $cmd"