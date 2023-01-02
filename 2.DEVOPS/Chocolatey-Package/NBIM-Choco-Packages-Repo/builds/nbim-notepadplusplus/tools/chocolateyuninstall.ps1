# Extract all installed software and get it removed

# Find the object from the package collection
$SearchString = "Notepad++"
$p = Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object  name -like "${SearchString}*"

# Extract the uninstall command from the package metadata
$cmd = $p.Meta.Attributes.Item("UninstallString") # QuietUninstallString not foud

# Perform the uninstall
Start-Process -FilePath $cmd -ArgumentList "/S" -PassThru -Wait