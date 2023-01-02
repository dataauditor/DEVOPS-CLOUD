#Mount to Fsx:'
$userName = ${env:FSXSERVICEUSER} 
${env:FSXSERVICEUSER}
${env:FSXSERVICEPASSWORD}
$securepassword = ConvertTo-SecureString -String ${env:FSXSERVICEPASSWORD} -AsPlainText -Force 
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $securepassword)
New-PSDrive -Credential $credObject -Root '\\nbim.no\Shareddrives\EUS_Win10ClientSW\App_Source_Files' -PSProvider filesystem -name U 

# Find Last Version Source Code From FileShare:
$FileShareObject=gci -Path '\\nbim.no\Shareddrives\EUS_Win10ClientSW\App_Source_Files\R *\Source' -Recurse | where {$_ -match '.exe'} | Sort-Object -Property {$_.LastWriteTime}  | select-object -first 1
Write-Output $FileShareObject



# Find Source Directory of $FileShareObject
$NewVersionFilePath=gci -Path '\\nbim.no\Shareddrives\EUS_Win10ClientSW\App_Source_Files\R *\Source' -Recurse | where {$_ -match '.exe'} | Sort-Object -Property {$_.LastWriteTime}  | select-object -first 1 | Select-Object FullName
$SourcePath=(Split-Path -Path $NewVersionFilePath).split('=') | select-object -Last 1



# Find The Name of the $FileShareObject
$AppName=(Split-Path -Path $NewVersionFilePath -Leaf).split('}')[0]



# Create the New Version:
$Version=($FileShareObject.Name.split('-') | select-object -last 1) -replace '.exe', ''

# Find Last Version Source Code From Bucket:
$BucketObject=(aws s3 ls s3://nbim-s3-euwe1-software-packages-chocolatey/RStudio/ --recursive | Where-Object {$_ } | Sort-Object -Property {$_.LastWriteTime} -Descending | where {$_ -match '.exe'}).split("/") | select-object -last 1
$Version=($Bucket.split('\') | Select-Object -last 1) -replace '.exe', ''
Write-Output $Bucket



# Compare the last version of Source Codes:
if ( $AppName -match $BucketObject )
{
    Write-Output "There is no new version"
}
Else {
    Write-Output "There is a new version"
	$confirmation=Read-Host "Do you want to download version $FileShareObject? yes or no?"
	Set-Location $SourcePath
	aws s3 sync .\ s3://nbuce1-choco/RStudio/$Version 
}
