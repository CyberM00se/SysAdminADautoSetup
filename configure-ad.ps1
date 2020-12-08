# Script: configure-ad.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: Once a domain environment is set up this will create the proper OUs and import users if needed. 

function OUStructure {
    $DistinguishedName = (Get-AdDomain | Select-Object -Property "DistinguishedName").DistinguishedName
    $DNSRoot = (Get-AdDomain | Select-Object -Property "DNSRoot").DNSRoot
    New-ADOrganizationalUnit -Name $DNSRoot -Path $DistinguishedName -ProtectedFromAccidentalDeletion $True -Description "Non-default AD objects go here. Made by PS script."
    New-ADOrganizationalUnit -Name "Users" -Path "OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "All user accounts should go in here. Made by PS script."
    New-ADOrganizationalUnit -Name "StandardUsers" -Path "OU=Users,OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "Standard domain user accounts go here. Made by PS script."
    New-ADOrganizationalUnit -Name "AdminUsers" -Path "OU=Users,OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "Domain admins and other ADM users go here. Made by PS script."
    New-ADOrganizationalUnit -Name "ServiceAccounts" -Path "OU=Users,OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "Accounts for different services go here. Made by PS script."
    New-ADOrganizationalUnit -Name "Computers" -Path "OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "All Computer objects should go here. Made by PS script."
    New-ADOrganizationalUnit -Name "Workstations" -Path "OU=Computers,OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "All workstation computers should go here. Made by PS script."
    New-ADOrganizationalUnit -Name "Servers" -Path "OU=Computers,OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "All server systems should go here. Made by PS script."
    New-ADOrganizationalUnit -Name "Other" -Path "OU=Computers,OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "Other systems should go here. Made by PS script."
    New-ADOrganizationalUnit -Name "Groups" -Path "OU=$DNSRoot,$DistinguishedName" -ProtectedFromAccidentalDeletion $True -Description "All security groups go here. Made by PS script."
}

OUStructure