# List of operating systems targeted
$win2016 = "Windows Server 2016 Datacenter"
$win2019 = "Windows Server 2019 Datacenter"
$win2022 = "Windows Server 2022 Datacenter"



# Get the operating system info
$OS = Get-ComputerInfo | Select-Object -ExpandProperty "WindowsProductName"

# Write Eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Enabling Windows Defender on $OS")


# Get location of batch file for windows2019/windows2022
$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$DefenderBatchFile = (gci $SourcesDir | ? name -match "WindowsDefenderATP.*$" | ? extension -match ".cmd" | select -first 1).FullName
$2016BatchFile     = (gci $SourcesDir | ? name -match "WindowsDefender2016ATP.*$" | ? extension -match ".cmd" | select -first 1).FullName
$2016MSIFile       = (gci $SourcesDir | ? name -match "md4ws" | ? extension -match ".msi" | select -first 1).FullName


<#
The Set-DeviceTag function gathers the Tag from an EC2 instance and writes the value for "easyrisk_id" to registry.
The tag will synchronize to Defender for Endpoint.
#>
Function Set-DeviceTag {

  #Defines the registry path for writing device tags to defender for endpoint
  $RegistryPath = 'HKLM:\Software\Policies\Microsoft\Windows Advanced Threat Protection\DeviceTagging'

  if (-not(Test-Path $RegistryPath)) {
      New-Item $RegistryPath -Force
  }

  Try
  {
    #Gets the easyrisk_id from the organizations api based off account id.
    [string]$token = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" = "21600"} -Method PUT -Uri http://169.254.169.254/latest/api/token
    $info = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info
    $accountid = $info | Select-Object -ExpandProperty "AccountId"
    Write-Output "Using account ID: $accountid"
    
    $Parameters = @{
        id = $accountid
    }
    
    $response = Invoke-WebRequest -Uri 'https://awsorganizations.api.nbim.no/accounts' -Body $Parameters -Method Get -UseBasicParsing
    if ($response.StatusCode -eq '200') {
        $content = Convertfrom-json $response.Content
        $er_id = $content | Select-Object -ExpandProperty "easyrisk_id"
    }

  }
Catch
  { 
    $tagerror = $_.Exception.Message
    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Failed To fetch Easy Risk ID from organizations API from this instance! - $tagerror")
    Write-Output "Failed To fetch Easy Risk ID from organizations API - Logging to EventLog."
    Write-Output $_.Exception.Message
  }

  # Sets the item for the registry path to correspond with the key
  if ( $er_id ) {
  echo "Setting easyrisk_id to $er_id"
  Set-ItemProperty -Path $RegistryPath -Type String -Name "Group" -Value $er_id -Force
  } else {
    Write-Output 'Device tag not set! Most likely the instance is unable to retrieve tag from IMDS - Review NBIM source in event log!'
  }

# Validate that the value corresponds with easyrisk id
  if ( $er_id ) {
    $validate = Get-ItemProperty -Path $RegistryPath -Name "Group"
    $validate.Group -eq $er_id
    Write-Output 'Easyrisk ID corresponds with the defined value.'

  } else {
    Write-Output 'Easyrisk ID does not correspond with the defined value.'
  }
}

# Function to enable windows defender on windows 2019 and windows 2022
function EnableDefender-Windows {

Try
  {
    Write-Output "Enabling Defender For $OS"
    Start-Process $DefenderBatchFile -NoNewWindow -Wait
  }
Catch
  { 
    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Enabling Windows Defender on $OS Failed!")
    Write-Output "Failed To Enable Windows Defender on $OS"
    Write-Output $_.Exception.Message
    exit 1
  }

}

# Function to enable windows defender on windows 2016
function EnableDefender-Windows2016 {

  Try
    {
      Write-Output "Enabling Defender For $OS"
      msiexec /i $2016MSIFile /quiet
      Write-Host "Sleeping for 15 seconds after MSI execution"; Start-Sleep -s 15
      Start-Process $2016BatchFile -NoNewWindow -Wait
    }
  Catch
    { 
      Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Enabling Windows Defender on $OS Failed!")
      Write-Output "Failed To Enable Windows Defender on $OS"
      Write-Output $_.Exception.Message
      exit 1
    }
  
  }

# Differentiate by operating system release
if ($OS -ge $win2019)
{
EnableDefender-Windows;
Write-Host "Sleeping for 15s after onboarding script has executed, setting device tag next."; Start-Sleep -s 15
Set-DeviceTag
}
else
{
EnableDefender-Windows2016;
Write-Host "Sleeping for 15s after MSI and onboarding script have executed, setting device tag next."; Start-Sleep -s 15
Set-DeviceTag
}
