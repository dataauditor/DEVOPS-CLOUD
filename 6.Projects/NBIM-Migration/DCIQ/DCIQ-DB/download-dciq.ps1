# Download and install script for Safeq software
# User changeable variables

$packageName = "dciq"
$WindowsTemp = "C:\Temp"

#Set local inbound firewall rules
New-NetFirewallRule -DisplayName "DCIQ" -Direction Inbound -LocalPort 80,443,1443 -Protocol TCP -Action Allow 

Function DownloadFromS3([uri]$S3URI)
{
    $SourceArchiveFileName = $S3URI.Segments[-1] # last index in the array is the leaf
    $S3Bucketname = $S3URI.Segments[1] -replace "/","" # bucket name is always the second segment
    $S3Region = ($S3URI.Authority -replace "s3-","") -replace ".amazonaws.com",""
    $S3FileKey = $S3URI.LocalPath -replace ("/"+$S3URI.Segments[1]),""
    $SourceArchiveFullName = Join-Path -Path $WindowsTemp -ChildPath $SourceArchiveFileName
  
    Write-Output "Downloading $packageName..."
    Copy-S3Object -BucketName $S3Bucketname `
                    -Key $S3FileKey `
                    -LocalFile $SourceArchiveFullName `
                    -Region $S3Region
   
    Write-Output "Success: $?"
    get-childitem $WindowsTemp
    
    $script:SourceArchiveFullName = $SourceArchiveFullName
    $script:SourceArchiveFileName = $SourceArchiveFileName
}


#copy installer file
#Copy-S3Object -BucketName nbim-l-s3-lab-euwe1-files -Key install-media/DCIQ/NBIM.zip  -LocalFile C:\Temp\NBIM.zip

DownloadFromS3 -S3URI "https://s3-eu-west-1.amazonaws.com/nbim-${env:env_short}-s3-${env:env}-euwe1-files/install-media/DCIQ/NBIM.zip"
DownloadFromS3 -S3URI "https://s3-eu-west-1.amazonaws.com/nbim-${env:env_short}-s3-${env:env}-euwe1-files/install-media/DCIQ/PanduitSZReports 9.1.exe"
DownloadFromS3 -S3URI "https://s3-eu-west-1.amazonaws.com/nbim-${env:env_short}-s3-${env:env}-euwe1-files/install-media/DCIQ/QlikViewServer_Win2012andUp.exe"
DownloadFromS3 -S3URI "https://s3-eu-west-1.amazonaws.com/nbim-${env:env_short}-s3-${env:env}-euwe1-files/install-media/DCIQ/SQL_Svr_Standard_Edtn_2014_SP3_64Bit.ISO"
