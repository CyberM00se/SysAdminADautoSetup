# Script: ad-automation-stager.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: Downloads all the necessary files for AD automation and configures tasks to complete the process. 

# This will need to be changed from the development branch once testing is complete.
$file2download = "https://raw.githubusercontent.com/CyPH3RSkULL5/SysAdminADautoSetup/dylan-development/automation.7z"

(New-Object System.Net.WebClient).DownloadFile($file2download,"automation.zip")

Expand-Archive -Path automation.zip