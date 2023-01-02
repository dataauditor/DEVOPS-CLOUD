Write-Host "Running install script for Qualys"

# #Create log source
# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-qualys")

# Get location of installation file
$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$InstallFile = (gci $SourcesDir | ? name -match "QualysCloudAgent_.*$" | ? extension -match ".exe" | select -first 1).FullName

Write-Host "Found install file at this location: $InstallFile"

Write-Host "Do we have the customer id and activation id ?"

#Get package parameters if any
$pp = Get-PackageParameters

Write-Host $pp["customerid"]
Write-Host $pp["activationid"]

if ($pp["customerid"] -AND $pp["activationid"]) {
    Write-Host "Found CustomerID and Activation ID in input"
    $qualys_cloudagent_customerid = $pp["customerid"]
    $qualys_cloudagent_activationid = $pp["activationid"]
    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Found parameters in the input..")
}

else {
    Write-Host "Input not provided for CustomerID and Activation ID. Will now try to find it in Parameter store"
    $qualys_cloudagent_customerid = (Get-SSMParameterValue -Name /qualys_cloudagent_customerid).Parameters[0].Value
    $qualys_cloudagent_activationid = (Get-SSMParameterValue -Name /qualys_cloudagent_activationid).Parameters[0].Value
    if ($qualys_cloudagent_customerid -AND $qualys_cloudagent_activationid){
        Write-Host "Yay! Found them in the parameter store!"
        Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Found the parameters in SSM Parameter store")
    }
    else {
        Write-Host "Not proceeding with installation as CustomerID and Activation ID were not found"
        Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: CustomerID and ActivationID parameters were not provided. Installation will fail")
        exit 1
    }
}

$arg_qualys = "CustomerId=${qualys_cloudagent_customerid} ActivationId=$qualys_cloudagent_activationid"

Try
 {
    Write-Output "Trying to install Qualys now.."
    $p=Start-Process $InstallFile $arg_qualys -NoNewWindow -Wait | Out-String
 }
 Catch
 { 
     Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Installation of Qualys Failed!")
     Write-Output "Oops.. failed to install Qualys"
     Write-Output $_.Exception.Message
     exit 1
 }

Write-Output "Successful installation, restarting Qualys services now.."
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Qualys successfully installed")
Get-Service -Include "*qualys*" | Stop-Service -Force
Get-Service -Include "*qualys*" | Set-Service -StartupType Automatic
Get-Service *qualys* | Start-Service
