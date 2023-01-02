# Extract all installed software and get it removed

# Find the object from the package collection
$SearchString = "Python 3.10"
$p = Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object  name -like "${SearchString}*" | select -First 1

# Extract the uninstall command from the package metadata
$cmd = $p.Meta.Attributes.Item("QuietUninstallString")

# Perform the uninstall
Start-Process -File cmd.exe -ArgumentList "/c", "echo Uninstalling $SearchString... &&", $cmd -NoNewWindow -Wait



# Find the object from the package collection
$SearchString = "Python Launcher"
$p = Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object  name -like "${SearchString}*" | select -First 1

# Stop if Python Launcher not found
if (-not $p) { exit 0 }

# Extract the uninstall command from the package metadata
$cmd = $p.Meta.Attributes.Item("UninstallString") # QuietUninstallString not foud
$cmd = $cmd + " /qn"

# Perform the uninstall
Start-Process -File cmd.exe -ArgumentList "/c", "echo Uninstalling $SearchString... &&", $cmd -NoNewWindow -Wait