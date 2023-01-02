# Extract all installed software and get it removed

# Find the object from the package collection
$SearchString = "SQL Server Management Studio"
$p = Get-Package -Provider Programs -IncludeWindowsInstaller | ?  name -match "${SearchString}"

# Extract the uninstall command from the package metadata
$UninstallCommand = $p.Meta.Attributes['QuietUninstallString']

# Perform the uninstall
# $p | Uninstall-Package -Force
Start-Process -FilePath cmd.exe -ArgumentList '/c', "echo Uninstalling $SearchString... &&", $UninstallCommand -Wait -NoNewWindow