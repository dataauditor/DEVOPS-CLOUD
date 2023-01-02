#
# This will be run under install and upgrade
#
#
# Log Status
#   770: Install and all is OK
#   771: Upgrade and all is OK

$Version        = "9.2.2.0-IBM-MQC-Win64"
$ResponseFile   = "Response9_2_2_0.ini"
#$Rand           = Get-Random -Minimum 10000 -Maximum 99999

Write-Host "Running install script"

# Write an eventlog
$LogSource      = "NBIM"
$Status         = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-mq client")

$RootDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir     = "${RootDir}"+"\sources"
$MSIDir         = $SourcesDir + "\MQClient\Windows\MSI\IBM MQ.msi"
$transforms     = "1033.mst"

$ZipFile = (gci $SourcesDir | ? name -match "$Version" | ? extension -match ".zip" | select -first 1).FullName
Expand-Archive -path $ZipFile -destinationpath $SourcesDir

$InstallFile    = (gci $SourcesDir -Recurse | ? name -match "IBM MQ" | ? extension -match ".msi" | select -first 1).FullName

$InstallArgs = @(
    '/i'
    "`"$MSIDir`""
    '/l'
    "`"C:\Windows\Temp\MQinstall.log`""
    '/q'
    "USEINI=`"$SourcesDir\$ResponseFile`""
    "TRANSFORMS=`"$transforms`""
)

if ( $InstallFile ) {
    Start-Process -FilePath msiexec.exe -ArgumentList $InstallArgs -Wait -NoNewWindow
    Write-Host "Starting to set Mq env.."
    cmd.exe /C C:\"Program Files"\MQM\bin\setmqenv.cmd -s
    $msg = "Chocolatey: Done installing nbim-mq"
    Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ($msg)
} else {
    Write-Host "No Installation file found. Looking for .msi inside ${SourcesDir}"
}

