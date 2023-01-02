# Usage 

## Programs installed with this package
- Microsoft .NET Core Runtime - 3.1.14 (x86)          3.1.14.29915
- Microsoft .NET Core 3.1.14 - Windows Server Hosting 3.1.14.21166
- Microsoft .NET Core Runtime - 3.1.14 (x64)          3.1.14.29915

Output is from this powershell commnad 
`Get-Package -Provider Programs -Name "*.NET*" | select name, version`

## Install
`choco  install -y nbim-dotnet-core-hosting3.1`