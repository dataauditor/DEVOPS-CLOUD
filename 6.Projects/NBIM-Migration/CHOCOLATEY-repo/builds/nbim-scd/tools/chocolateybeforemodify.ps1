#When choco upgrade of nbim-scd is done, this will set the install parameter to update
#and then the chocoinstall.ps1 file will take care of the rest.
Install-ChocolateyEnvironmentVariable "operation_type" "update"