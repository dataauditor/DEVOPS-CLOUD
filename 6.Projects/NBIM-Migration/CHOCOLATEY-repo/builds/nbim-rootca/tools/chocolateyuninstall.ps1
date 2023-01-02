Write-Host "Running uninstallation script"

#Checking if the cert already exists 
if ((Get-ChildItem -path Cert:\LocalMachine\Root).subject -contains "CN=NBIM Internal Root CA 02 G1, O=NBIM, C=NO")
{
#Remove Certificate to the cert store
Write-Host "Removing Root CA cert  "
Get-ChildItem -path Cert:\LocalMachine\Root | Where-Object { $_.subject -eq "CN=NBIM Internal Root CA 02 G1, O=NBIM, C=NO" } | Remove-Item
}

if (!((Get-ChildItem -path Cert:\LocalMachine\Root).subject -contains "CN=NBIM Internal Root CA 02 G1, O=NBIM, C=NO"))
  {
  Write-host "Successfully removed Root CA certificate"
  }
  else
  {
  Write-host "Failed to remove the Root CA certificate"
  }