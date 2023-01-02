# Log Status
#   750: Install failed.
#   770: Install and all is OK
#   771: Upgrade and all is OK

Write-Host "Running install script"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
$URL = "www.bloomberg.com"

Write-Host "Checking connectivity to Bloomberg servers.."
$result = Test-NetConnection $URL -Port 443 | ? TcpTestSucceeded -match "True" | select TcpTestSucceeded
if ($result -eq $null) {
    $Status = 750
    $Message = "Chocolatey: Bloomberg servers need to be whitelisted to download and configure Bloomberg components. The package will now exit.."

    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ($Message)
    Write-Host $Message
    Exit 1
}

Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-bloomberg")

$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"

# Download Matlab from S3
# 1. Use EC2 metadata API to get account ID
Copy-S3Object -BucketName nbim-s3-euwe1-software-packages-chocolatey/Bloomberg/105.5.80 -Key sotr105_5_80.exe -LocalFolder $SourcesDir

# $ZipFile = (gci $SourcesDir | ? name -match "sotr_*$" | ? extension -match ".exe" | select -first 1).FullName
# Expand-Archive -path $ZipFile -destinationpath $SourcesDir

$InstallFile = (gci $SourcesDir -Filter 'sotr105_5_80.exe').fullname 
if ( $InstallFile ) {
  echo $InstallFile
  Start-Process $InstallFile -ArgumentList "/s" -Wait
  $Status = 750
  $Message = "Chocolatey: nbim-bloomberg requires that you restart the computer..."
  Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ($Message)
  Write-Host $Message
} else {
  Write-Host "No Installation file found. Looking for .exe inside ${SourcesDir}"
}
