# Script: file-zip.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: Just zips the folder so when I push to the repo it is saved in a zip format. 

Remove-Item zip.zip  # Removes the current zip archive. 
Compress-Archive -Path automation -DestinationPath zip.zip  # Creates the new zip archive to uplaod. 