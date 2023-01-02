# Find the object from the package collection
# Remove x64 version
$SearchString = ".NET Runtime - 5.0.5 (x64)"
$p = Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object  name -like "*${SearchString}*" | select -First 1

# Extract the uninstall command from the package metadata
$cmd = $p.Meta.Attributes.Item("QuietUninstallString")

# Perform the uninstall
Start-Process -File cmd.exe -ArgumentList "/c", "echo Uninstalling $SearchString... &&", $cmd -NoNewWindow -Wait
