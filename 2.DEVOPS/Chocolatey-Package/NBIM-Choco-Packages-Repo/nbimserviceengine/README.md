# NBIM Service Engine

This template code will create an NBIM Service from Powershell scripts and deploy as a chocolatey installable package.

[Link to Confluence.](https://nbagile.atlassian.net/wiki/x/sAHkx)

## Use case
If you need a server to run a specific code during startup/shutdown this service engine will help. The services will respond to START and STOP commands by your choosing and thereby allowing you to control what happends during provisioning, if a machine reboots, gets terminated or is subject to an auto-scaling-group.
Use cases might be:
1. You have a server that needs to register a license, and give that license up when not in use.
2. You have multiple machines in a loadbalanced architecture, but only want one active machine at a time
3. You have special commands that should run once or every time a machine start up
4. You want to take backups of local content to S3 or to a database when machine shuts down

## CI/CD
The process uses AzureDevops CI/CD templates to trigger the choco build process
All deployments are using Chocolatey. See [Chocolatey Users Guide](https://nbagile.atlassian.net/wiki/x/wAA4cQ).


# Usage
This code should be referenced as a Template in AzDo.
Add these code snippets to your AzDo pipeline:
```
trigger: # Whatever trigger suits you

pool:    # Whatever pool. MUST SUPPORT POWERSHELL and required CSharp modules

resources:
  # Required in order to reference templates and to checkout this repo
  repositories:
    - repository: chocolatey_packages
      type: github
      name: NBIM/chocolatey_packages
      ref: refs/heads/main
      endpoint: NBIM

# Two checkout's and a template
# The two checkout's are required to checkout the local code in 'self' (i.e. your repo) 
# as well accessing the scripts in the chocolatey_packages repo
# The template does the actual choco packaging and release management
steps:
  - checkout: self
  - checkout: chocolatey_packages
  - template: .pipeline-templates/nbimserviceengine.v1.yaml@chocolatey_packages
    parameters:
      ScriptFile:   [REQUIRED] Path to the ps1 service script containing your START, STOP, etc command blocks
      ServiceName:  [REQUIRED] Your service name. Single word, no special characters. i.e. "myservice" or "scd-mux-service"
      Version:      [Optional] version number. Will be set automatically to the pipeline release if omitted.
      Description:  [Optional] Will be set automatically if omitted
      Dependency:   [Optional] Annother choco packages that must be installed before this service. Currently supports only one.
```
# Your Powershell service script
The Powershell script, that you add as the parameter to 'ScriptFile' can respond to $Start, $Stop and $RunBeforeStop parameters. A simple example below:
```
Param (
  [Switch]$Stop,                  # [OPTIONAL] Commands to run when the Stop-Service command is issued
  [Switch]$RunBeforestop,         # [OPTIONAL] Perhaps you want something to happen before service is terminated
  [Switch]$Start                  # [REQUIRED] The service needs to know what to do when starting
)

$LogFile = "\temp\hello_world_service.txt"

if ($RunBeforeStop) {
  # This code will run BEFORE the service is terminated
  " ---- HelloWorld RUN BEFORE STOP ----" | Out-File -encoding ascii -Append $LogFile
}

if ($Stop) {
  # This code will run when the Stop-Service command is issued
  " ---- HelloWorld is stopping ----"     | Out-File -encoding ascii -Append $LogFile
}

if ($Start) {
  # This code will run when the Start-Service command is issued
  " ---- HelloWorld is starting ----"     | Out-File -Encoding ascii -Append $LogFile

# You can put your code in a while loop - or not! 
# The SCM engine will still think the service is running so you can run STOP commands etc.
  while ($true) {
    Date                                  | Out-File -Encoding ascii -Append $LogFile
    "HelloWorld is Running as service"                  | Out-File -Encoding ascii -Append $LogFile
    sleep 5
  }
}
```
# Edge cases
## Run a command once (and only once)
If you need to run the code only once, then you should add some check-file to indicate that the file has already been run.
```
# Powershell example code
If ($Start) {
  $LockFile = '/windows/temp/mylockfile.lock'
  if (Test-Path $LockFile) {
    # The file does not exist. I.e. Run this code and at the end: create $LockFile
    If (<all is well>) {
      Write-Output "Success" | Out-File $Lockfile
    }
  } else {
    # The above code has already been run, which means we should probably do something else
  }
}
```
## I need to run my code before x happens
If you need to run code before something else, perhaps before domainjoin, make sure your service starts before other services (like the AmazonSSMAgent) by changing the Dependency to the relevant service.
# Dependencies
The Service engine uses the Chocolatey Building Template to create the actual choco package and deploy it to the appropriate repositories.
