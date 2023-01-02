#
# This will be run under install and upgrade
#
# Log Status
#   770: Install and all is OK
#   771: Upgrade and all is OK

$Version = "windows_x86_64_9.0.18"
$Setup = "controlm_setup"

Write-Host "Running install script"

# Write an eventlog
$LogSource      = "NBIM"
$Status         = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of nbim-controlm")

$RootDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir     = "${RootDir}"+"\sources"

# Get package parameters if any
$pparam = Get-PackageParameters

if(!$pparam['servers']) {
    Write-Host "Setting up Servers for $env"
    switch ($pparam['env']) {
        dev { $servers="awdctrlmdev01|awdctrlmdev02" }
        test { $servers="awtctrlmuat01|awtctrlmuat02" }
        prod { $servers="awpctrlmprd01|awpctrlmprd02" }
    }
}
else {
    $servers = $pparam['servers']
}

if (!$servers) {
    Write-Host "Neither servers were provided in the package param, nor env variable. Exiting installation.."
    exit 1
}

$ZipFile = (gci $SourcesDir | ? name -match "$Version" | ? extension -match ".zip" | select -first 1).FullName
Expand-Archive -path $ZipFile -destinationpath $SourcesDir

$SetupFile = (gci $SourcesDir | ? name -match "$Setup" | ? extension -match ".zip" | select -first 1).FullName
Expand-Archive -path $SetupFile -destinationpath $SourcesDir

# Pick primary server
$server_list = $servers.Split("|")
Write-Host "primary server - " $server_list[0]

$xml_file = "$SourcesDir\controlm_setup.xml"

# Update XML file with servers
Write-Host "Updating xml file with the correct values for Primary and Authorized servers.."
(get-content $xml_file) -replace "#PRIMARYSERVER#", $server_list[0] -replace "#AUTORIZEDSERVERS#", $servers | Set-Content $xml_file

$InstallFile    = (gci $SourcesDir -Recurse | ? name -match "setup" | ? extension -match ".exe" | select -first 1).FullName

# Start the installer
$params = @("-silent", "`"$xml_file`"")
Write-Host "$InstallFile $params"
Write-Host "Beginning $Version install..." -nonewline

$result = Start-Process $InstallFile $params -NoNewWindow -Wait
Write-Host $result

if ( $pparam["user"] -And $pparam["password"] )  {
    Write-Host "Starting to configure User credentials"

    # Control-M communication ports
    Write-Host "Adding Inbound rules in Firewall"
    netsh advfirewall firewall add rule name="Control M Inbound" dir=in action=allow protocol=TCP localport=7006

    Write-Host "Getting Control-M agent credentials from SSM."
    $user = (Get-SSMParameterValue -Name $pparam["user"]).Parameters[0].Value
    $c_password = (Get-SSMParameterValue -Name $pparam["password"] -WithDecryption $True).Parameters[0].Value

    Write-Host "Alter user on control-M agent service."

      # Add Control-M service user to Log on as a service.
    Write-Host "Adding Control-M service user to Log on as a service."
    if (!(Get-Module -ListAvailable -Name Carbon)){
        Install-PackageProvider -Name NuGet -Confirm:$false -Force | Out-Null
        Install-Module -Name 'Carbon' -AllowClobber -Confirm:$false -Force | Out-Null
    }
    Import-Module Carbon
    Carbon\Grant-Privilege -Identity $user -Privilege "SeServiceLogonRight"
    Write-Host "Adding Control-M service user to Log on as a service done."

    # Change user and password on Control-M agent service
    Write-Host "Changing Control-M service user."

    $service_name = "Control-M/Agent"
    Write-Host "service_name - " $service_name

    $service_object = Get-Service -Name $service_name
    Write-Host "service_object.Name - " $service_object.Name

    Stop-Service -Name $service_name

    $password = ConvertTo-SecureString -String $c_password -AsPlainText -Force
    $filter = "name='" + ${service_object}.Name + "'"
    Write-Host "filter - " $filter
    $service = Get-WmiObject -Class win32_service -filter $filter
    Write-Host "service.StartName - " $service.StartName
    $service
    $credential = New-Object System.Management.Automation.PSCredential ($user,$password)

    # Change service
    $result = $service.change($null,$null,$null,$null,$null,$null,$credential.UserName,$credential.GetNetworkCredential().Password,$null,$null,$null)
    $result

    $service_after = Get-WmiObject -Class win32_service -filter $filter
    Write-Host "service_after.StartName - " $service_after.StartName
    $service_after

    Start-Service -Name $service_name

    # Check if service user has been changed
    $service_after_start = Get-WmiObject -Class win32_service -filter $filter
    Write-Host "service_after_start.StartName - " $service_after_start.StartName
    $service_after_start

    Write-Host "Changing Control-M service user done."

}