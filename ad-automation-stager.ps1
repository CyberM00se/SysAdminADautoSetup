# Script: ad-automation-stager.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: Downloads all the necessary files for AD automation and configures tasks to complete the process. 

# This will need to be changed from the development branch once testing is complete.
$file2download = "https://raw.githubusercontent.com/CyPH3RSkULL5/SysAdminADautoSetup/dylan-development/zip.zip"
$currentPath = (Get-Location).path

(New-Object System.Net.WebClient).DownloadFile($file2download,"automation.zip")  # Downloads the ZIP archive from the repo. 
Expand-Archive -Path automation.zip -DestinationPath .  # Uncompresses the archine in the current directory (.). 
Remove-Item -Path .\zip.zip  # Cleans up the current directory by removing the zip file. 

function scheduletask {
    $action = New-ScheduledTaskAction -Execute "$currentPath\automation\configure-ad.ps1"
    $trigger = New-ScheduledTaskTrigger -Once -AtStartup
    $principal = New-ScheduledTaskPrincipal "Administrator"
    $task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger
    Register-ScheduledTask -TaskName "AD Automation" -Description "https://github.com/CyPH3RSkULL5/SysAdminADautoSetup/tree/main" -InputObject $task
}

scheduletask

.\automation\install-adds.ps1

Read-Host ("Press any key to contuinue....")