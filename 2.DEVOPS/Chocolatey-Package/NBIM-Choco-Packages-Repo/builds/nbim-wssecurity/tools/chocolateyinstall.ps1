# Applies security for windows 
$RootDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$SourcesDir = "${RootDir}"+"\Sources"
$FilesDir   = "${RootDir}"+"\Files"
$WindowsTemp = "C:\Windows\Temp"

# Imports variables
$pp = Get-PackageParameters

Write-host "Applying PSSecurity"
if ($pp['Test']) {$Test = $pp['Test']}
& "$FilesDir\apply-pssecurity.ps1" -Test $test

Write-host "Applying ADV20006 mitigation"
& "$FilesDir\apply-mitigationADV20006.ps1"

Write-host "Applies Microsoft Baseline Security (MCSB)"
$version = (Get-CimInstance Win32_OperatingSystem | Select-Object -Property Caption)

switch -Wildcard ($version) {
  "*2019*" {$mscb = "mscb2019"; Break}
  "*2016*" {$mscb = "mscb2016"; Break}
  "*2012*" {$mscb = "mscb2016"; Break} 
  default {$mscb = $null; Write-host "Windows OS not supported, will not apply mscb. Version: $version"}
}

if ($mscb) {
    $ZipFolder = "$SourcesDir\${mscb}.zip"
    Write-host "Installing $ZipFolder."

    # Check for zip
    If (!(Test-Path -Path $ZipFolder)){
        Write-Error "$ZipFolder not found!"
        Exit
    }

    Expand-Archive -Path $ZipFolder -DestinationPath $WindowsTemp -Force
    & "$FilesDir\Install-${mscb}.ps1"
}