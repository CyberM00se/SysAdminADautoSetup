# Script: install-adds.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: This script is designed to install and configure the Active Directory Domain Services role on a Windows Server.

$domainName = Read-Host "What would you like your domain name to be?: "
Write-Host "Installing the ADDS..."
Add-WindowsFeature AD-Domain-Services
Write-Host "Done."
Write-Host "Installing the ADDS Tools"  # This shit dont work. Need to re add
Write-Host "Done."
Write-Host "Configuring ADDS and DNS"
Install-ADDSForest -DomainName $domainName -InstallDNS
Write-Host "Done."
Write-Host -NoNewLine 'Press any key to exit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');