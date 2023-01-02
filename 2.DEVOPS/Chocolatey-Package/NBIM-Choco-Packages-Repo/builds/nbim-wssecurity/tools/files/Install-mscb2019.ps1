$ScriptRoot = "C:\Windows\Temp\MSCB2019"

#Apply Windows Server 2019 Member Server Security
Write-Output -ForegroundColor Cyan "Configuring Windows Server 2010 Member Server security settings and policies..."
& "$ScriptRoot\Tools\LGPO.exe" /v /g "$scriptroot\GPOs\{C92CC433-A4EA-47B1-8B24-6FF732940E0E}"
Write-Output -ForegroundColor Cyan "Windows Server 2019 Member Server Local Policy Applied"

#Apply Windows Defender Local Policy
Write-Output -ForegroundColor Cyan "Configuring Windows Server 2019 Defender policies..."
& "$ScriptRoot\Tools\LGPO.exe" /v /g "$scriptroot\GPOs\{FEE76283-957E-4B25-9380-2F737E13E972}"
Write-Output -ForegroundColor Cyan "Windows Defender Local Policy Applied"

#Apply Windows Credential Guard Policy
Write-Output -ForegroundColor Cyan "Configuring Windows Credential Guard policies..."
& "$ScriptRoot\Tools\LGPO.exe" /v /g "$scriptroot\GPOs\{FEE76283-957E-4B25-9380-2F737E13E972}"
Write-Output -ForegroundColor Cyan "Windows Defender Local Policy Applied"

$CurrentVerPoliciesPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\'
$PoliciesPath = 'HKLM:\Software\Policies\Microsoft\'
$ControlSetPath = 'HKLM:\SYSTEM\CurrentControlSet\'

#Server 9 Member Server Security (registry.pol settings written directly)
Write-Output "Enabling Computer Policies from MSCB for Server 2019"
New-Item -Path $CurrentVerPoliciesPath"Explorer" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $CurrentVerPoliciesPath"Explorer"  -Name "NoDriveTypeAutoRun" -Value 255 -Force
Set-ItemProperty -Path $CurrentVerPoliciesPath"Explorer"  -Name "NoAutorun" -Value 1 -Force

New-Item -Path $CurrentVerPoliciesPath"System" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $CurrentVerPoliciesPath"System"  -Name "DisableAutomaticRestartSignOn" -Value 1 -Force
Set-ItemProperty -Path $CurrentVerPoliciesPath"System" -Name "LocalAccountTokenFilterPolicy" -Value 0 -Force

New-Item -Path $PoliciesPath"Biometrics\FacialFeatures" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Biometrics\FacialFeatures" -Name "EnhancedAntiSpoofing" -Value 1 -Force

New-Item -Path $PoliciesPath"Windows\EventLog\Application" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\EventLog\Application" -Name "MaxSize" -Value 32768 -Force

New-Item -Path $PoliciesPath"Windows\EventLog\Security" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\EventLog\Security" -Name "MaxSize" -Value 196608 -Force

New-Item -Path $PoliciesPath"Windows\EventLog\System" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\EventLog\System" -Name "MaxSize" -Value 32768 -Force

New-Item -Path $PoliciesPath"Windows\EventLog\Windows\Explorer" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\EventLog\Windows\Explorer" -Name "NoAutoplayfornonVolume" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"Windows\EventLog\Windows\Explorer" -Name "NoDataExecutionPrevention" -Value 0 -Force
Set-ItemProperty -Path $PoliciesPath"Windows\EventLog\Windows\Explorer" -Name "NoHeapTerminationOnCorruption" -Value 0 -Force

New-Item -Path $PoliciesPath"Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" -Name "NoBackgroundPolicy" -Value 0 -Force
Set-ItemProperty -Path $PoliciesPath"Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" -Name "NoGPOListChanges" -Value 0 -Force

New-Item -Path $PoliciesPath"Windows\Installer" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\Installer" -Name "AlwaysInstallElevated" -Value 0 -Force
Set-ItemProperty -Path $PoliciesPath"Windows\Installer" -Name "EnableUserControl" -Value 0 -Force

New-Item -Path $PoliciesPath"Windows\LanmanWorkstation" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\LanmanWorkstation" -Name "AllowInsecureGuestAuth" -Value 0 -Force

New-Item -Path $PoliciesPath"Windows\NetworkProvider\HardenedPaths" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\NetworkProvider\HardenedPaths" -Name "\\*\SYSVOL" -Value "RequireMutualAuthentication=1,RequireIntegrity=1" -Force
Set-ItemProperty -Path $PoliciesPath"Windows\NetworkProvider\HardenedPaths" -Name "\\*\NETLOGON" -Value "RequireMutualAuthentication=1,RequireIntegrity=1" -Force

New-Item -Path $PoliciesPath"Windows\Personalization" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\Personalization" -Name "NoLockScreenCamera" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"Windows\Personalization" -Name "NoLockScreenSlideshow" -Value 1 -Force

New-Item -Path $PoliciesPath"Windows\PowerShell\ScriptBlockLogging" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 1 -Force

New-Item -Path $PoliciesPath"Windows\System" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\System" -Name "DontDisplayNetworkSelectionUI" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"Windows\System" -Name "EnumerateLocalUsers" -Value 0 -Force
Set-ItemProperty -Path $PoliciesPath"Windows\System" -Name "EnableSmartScreen" -Value 1 -Force

New-Item -Path $PoliciesPath"Windows\Windows Search" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows\Windows Search" -Name "AllowIndexingEncryptedStoresOrItems" -Value 0 -Force

New-Item -Path $PoliciesPath"Windows NT\MitigationOptions" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows NT\MitigationOptions" -Name "MitigationOptions_FontBocking" -Value "1000000000000" -Force

New-Item -Path $PoliciesPath"Windows NT\MitigationOptions" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows NT\Rpc" -Name "RestrictRemoteClients" -Value 1 -Force

New-Item -Path $PoliciesPath"Windows NT\Terminal Services" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"Windows NT\Terminal Services" -Name "DisablePasswordSaving" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"Windows NT\Terminal Services" -Name "fDisableCdm" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"Windows NT\Terminal Services" -Name "fPromptForPassword" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"Windows NT\Terminal Services" -Name "fEncryptRPCTraffic" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"Windows NT\Terminal Services" -Name "MinEncryptionLevel" -Value 3 -Force

New-Item -Path $PoliciesPath"WindowsFirewall" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall" -Name "PolicyVersion" -Value 538 -Force

New-Item -Path $PoliciesPath"WindowsFirewall\DomainProfile" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\DomainProfile" -Name "DefaultOutboundAction" -Value 0 -Force
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\DomainProfile" -Name "DefaultInboundAction" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\DomainProfile" -Name "EnableFirewall" -Value 1 -Force

New-Item -Path $PoliciesPath"WindowsFirewall\PrivateProfile" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\PrivateProfile" -Name "DefaultOutboundAction" -Value 0 -Force
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\PrivateProfile" -Name "DefaultInboundAction" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\PrivateProfile" -Name "EnableFirewall" -Value 1 -Force

New-Item -Path $PoliciesPath"WindowsFirewall\PublicProfile" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\PublicProfile" -Name "DefaultOutboundAction" -Value 0 -Force
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\PublicProfile" -Name "DefaultInboundAction" -Value 1 -Force
Set-ItemProperty -Path $PoliciesPath"WindowsFirewall\PublicProfile" -Name "EnableFirewall" -Value 1 -Force

New-Item -Path $ControlSetPath"Control\SecurityProviders\WDigest" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $ControlSetPath"Control\SecurityProviders\WDigest" -Name "UseLogonCredential" -Value 0 -Force

New-Item -Path $ControlSetPath"Policies\EarlyLaunch" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $ControlSetPath"Policies\EarlyLaunch" -Name "DriverLoadPolicy" -Value 3 -Force

#Enable SpeculationControl (Spectre/Meltdown Mitigation)
Write-Output "Enabling mitigation for Spectre/Meltdown"
New-Item $ControlSetPath"Control\Session Manager\Memory Management" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $ControlSetPath"Control\Session Manager\Memory Management" -Name "FeatureSettingsOverride" -Value 72 -Force
Set-ItemProperty -Path $ControlSetPath"Control\Session Manager\Memory Management" -Name "FeatureSettingsOverrideMask" -Value 3 -Force

#Disable NetBIOS on network adapters MS 03-034
Write-Output "Disabling NetBIOS on network adapters"
$adapters=(Get-WmiObject win32_networkadapterconfiguration )
Foreach ($adapter in $adapters){
  Write-Output $adapter
  $adapter.settcpipnetbios(2)
}

#Disable LLMNR vulnerability MS 11-030
New-Item -Path $PoliciesPath"Windows NT\DNSClient" -Force
Set-ItemProperty -Path $PoliciesPath"Windows NT\DNSClient" -Name "EnableMulticast" -Value 0 -Force


#Enable logging of comand line in process creation events
New-Item -Path $CurrentVerPoliciesPath"System\Audit" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $CurrentVerPoliciesPath"System\Audit" -Name ProcessCreationIncludeCmdLine_Enabled -Value 1