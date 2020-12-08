# Script: install-adds.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: This script is designed to install and configure the Active Directory Domain Services role on a Windows Server.

$domainName = Read-Host "What would you like your domain name to be?: "
Write-Host "Installing the ADDS..."
Add-WindowsFeature AD-Domain-Services
Write-Host "Done."
Write-Host "Installing the ADDS Tools"  # This shit dont work.
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 –Online
Add-WindowsCapability -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0 –Online
Add-WindowsCapability -Name Rsat.Dns.Tools~~~~0.0.1.0 –Online
Write-Host "Done."
Write-Host "Configuring ADDS and DNS"
Install-ADDSForest -DomainName $domainName -InstallDNS
Write-Host "Done."