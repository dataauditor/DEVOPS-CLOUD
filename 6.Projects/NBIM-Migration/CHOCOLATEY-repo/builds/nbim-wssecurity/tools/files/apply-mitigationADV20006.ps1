  
<#
Apply-MitigationADV20006.ps1
Implements mitigation for ADV200006
PowerShell. x64 only.
#>
function Apply-MitigationADV20006
{
    #Set Location to System32
    Set-Location -Path $env:windir"\system32\"
    $Exists = Test-Path .\atmfd.dll
    if ($Exists -eq $true) {
        #Gets the current ACL and modifies it to grant "INTERACTIVE" Full Control.
        $ObjectAcl = Get-Acl .\atmfd.dll
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("INTERACTIVE","FullControl","Allow")

        #Sets the Acl for the object.
        $ObjectAcl.SetAccessRule($AccessRule)
        $ObjectAcl | Set-Acl .\atmfd.dll
        Rename-Item -LiteralPath .\atmfd.dll -NewName x-atmfd.dll -Verbose
        Write-Output "Mitigation added.."

    }

    else {
        Write-Output "DLL not found.."
    }
}

Apply-MitigationADV20006