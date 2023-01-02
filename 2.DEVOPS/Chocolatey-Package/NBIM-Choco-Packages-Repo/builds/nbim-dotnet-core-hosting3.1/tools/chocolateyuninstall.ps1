# Find the object from the package collection
$SearchString = "Microsoft .NET Core 3.1.14 - Windows Server Hosting"
$p = Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object  name -like "${SearchString}*" | select -First 1

# Extract the uninstall command from the package metadata
$cmd = $p.Meta.Attributes.Item("QuietUninstallString")

# Perform the uninstall
Start-Process -File cmd.exe -ArgumentList "/c", "echo Uninstalling $SearchString... &&", $cmd -NoNewWindow -Wait

# Also installs these 
# Microsoft .NET Core Runtime - 3.1.14 (x86)          3.1.14.29915
# Microsoft .NET Core 3.1.14 - Windows Server Hosting 3.1.14.21166
# Microsoft .NET Core Runtime - 3.1.14 (x64)          3.1.14.29915
# output from Get-Package -Provider Programs -Name "*.NET*" | select name, version