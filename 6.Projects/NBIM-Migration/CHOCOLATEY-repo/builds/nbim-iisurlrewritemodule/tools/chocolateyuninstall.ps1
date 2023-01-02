


$productCode = (Get-Package | Where-Object Name -like "IIS URL Rewrite Module*").Meta.Attributes.Item('ProductCode')
if ($productCode -notlike "{*-*-*-*-*}") { throw "NBIM-error: Did not fint productcode to uninstall" }


# msiexec.exe /x {11111111-1111-1111-1111-11111111111X}
Start-Process -FilePath "msiexec.exe" -Args ("/x {0} /qn /norestart" -f $productCode) -Wait -PassThru -NoNewWindow
