# Script: automation-stager.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: Downloads all the necessary files for AD automation and configures tasks to complete the process. 

# This will need to be changed from the development branch once testing is complete.
$file2download = "https://raw.githubusercontent.com/CyPH3RSkULL5/SysAdminADautoSetup/dylan-development/zip.zip"
$currentPath = (Get-Location).path

(New-Object System.Net.WebClient).DownloadFile($file2download,"zip.zip")  # Downloads the ZIP archive from the repo. 
Expand-Archive -Path zip.zip -DestinationPath .  # Uncompresses the archine in the current directory (.). 
Remove-Item -Path .\zip.zip  # Cleans up the current directory by removing the zip file. 

$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
Register-ScheduledJob -Trigger $trigger -FilePath "$currentPath\automation\configure-ad.ps1" -Name "AD Automation"  # Use Get-Job to see if job was complete.
Unblock-File -Path .\automation\configure-ad.ps1

$process = Start-Process powershell -ArgumentList ("-ExecutionPolicy Bypass -noprofile " + ".\automation\install-adds.ps1") -PassThru
$process.WaitForExit($waitTimeMilliseconds)

Write-Host -NoNewLine 'Press any key to exit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');  # This is for viewing errors. In future versions it should be removed.