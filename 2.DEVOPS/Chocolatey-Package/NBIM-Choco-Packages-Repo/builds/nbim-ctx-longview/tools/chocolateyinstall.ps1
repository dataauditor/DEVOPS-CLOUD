#
# This will be run under install and upgrade
#
# Log Status
#   770: Install and all is OK
#   771: Upgrade and all is OK

Write-Host "Running Longview install script for VDA"

$ZipName = "Longview-Trading-System"
$longviewtools = "Build_6300_Linedata_FIXLogReader"
$SetupFile = "LongView"

# Write an eventlog
$LogSource  = "NBIM"
$Status     = 770
Write-EventLog -LogName Application -Source ${LogSource} -EventId $Status -Message ("Chocolatey: Performing install of of nbim-ctx-longview")

$RootDir            = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir         = "${RootDir}"+"\Sources"
$Installdir         = "C:\Programs\LinedataServices\75.1.1.6307\"
$ComputerName       = hostname

$ZipFile = (gci $SourcesDir | ? name -match "$ZipName" | ? extension -match ".zip" | select -first 1).FullName
Expand-Archive -path $ZipFile -destinationpath "C:\Programs\LinedataServices\" -Force

$LVToolsZipFile = (gci $SourcesDir | ? name -match "$longviewtools" | ? extension -match ".zip" | select -first 1).FullName
Expand-Archive -path $LVToolsZipFile -destinationpath "C:\Programs\LinedataServices\" -Force

$InstallFile = (gci $Installdir | ? name -match "$SetupFile" | ? extension -match ".exe" | select -first 1).FullName

if($ComputerName.contains("AWTCTX")){
    $config_file = "C:\Programs\LinedataServices\75.1.1.6307\AddIns\SpinOffClient\tool.spinoff.config"
    (get-content $config_file) -replace '"prod"', '"test"' | Set-Content $config_file
}

$FilePath1 = $Installdir + "msvcr70.dll"
$FilePath2 = $Installdir + "mfc70.dll"
$FilePath3 = $Installdir + "rwuxthemes.dll"
$FilePath4 = $Installdir + "og903nodbas.dll"
$FilePath5 = $Installdir + "ogc903r.dll.dll"
$FilePath6 = $Installdir + "ogocxgrd.ocx"

$run=0
do
{
    $run++
    $result = Start-Process -FilePath 'regsvr32.exe' -Args "/s $FilePath1" -Wait -NoNewWindow -PassThru
    Write-Host "Registered" + $FilePath1
    Write-Host "Exit code: " $result.ExitCode
    Write-Host "Try number: " $run
    Start-Sleep -Seconds 5
} while ($result.ExitCode -ne 0 -and $run -le 4)

$run=0
do
{
    $run++
    $result = Start-Process -FilePath 'regsvr32.exe' -Args "/s $FilePath2" -Wait -NoNewWindow -PassThru
    Write-Host "Registered" + $FilePath2
    Write-Host "Exit code: " $result.ExitCode
    Write-Host "Try number: " $run
    Start-Sleep -Seconds 5
} while ($result.ExitCode -ne 0 -and $run -le 4)

$run=0
do
{
    $run++
    $result = Start-Process -FilePath 'regsvr32.exe' -Args "/s $FilePath3" -Wait -NoNewWindow -PassThru
    Write-Host "Registered" + $FilePath3
    Write-Host "Exit code: " $result.ExitCode
    Write-Host "Try number: " $run
    Start-Sleep -Seconds 5
} while ($result.ExitCode -ne 0 -and $run -le 4)

$run=0
do
{
    $run++
    $result = Start-Process -FilePath 'regsvr32.exe' -Args "/s $FilePath4" -Wait -NoNewWindow -PassThru
    Write-Host "Registered" + $FilePath4
    Write-Host "Exit code: " $result.ExitCode
    Write-Host "Try number: " $run
    Start-Sleep -Seconds 5
} while ($result.ExitCode -ne 0 -and $run -le 4)

$run=0
do
{
    $run++
    $result = Start-Process -FilePath 'regsvr32.exe' -Args "/s $FilePath5" -Wait -NoNewWindow -PassThru
    Write-Host "Registered" + $FilePath5
    Write-Host "Exit code: " $result.ExitCode
    Write-Host "Try number: " $run
    Start-Sleep -Seconds 5
} while ($result.ExitCode -ne 0 -and $run -le 4)

$run=0
do
{
    $run++
    $result = Start-Process -FilePath 'regsvr32.exe' -Args "/s $FilePath6" -Wait -NoNewWindow -PassThru
    Write-Host "Registered" + $FilePath6
    Write-Host "Exit code: " $result.ExitCode
    Write-Host "Try number: " $run
    Start-Sleep -Seconds 5
} while ($result.ExitCode -ne 0 -and $run -le 4)

$result = Start-Process -FilePath $InstallFile
