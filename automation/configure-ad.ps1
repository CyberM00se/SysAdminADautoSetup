# Script: configure-ad.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: Once a domain environment is set up this will create the proper OUs and import users if needed. 

# These variables are used in 
$DistinguishedName = (Get-AdDomain | Select-Object -Property "DistinguishedName").DistinguishedName
$DNSRoot = (Get-AdDomain | Select-Object -Property "DNSRoot").DNSRoot
$OUPath = "OU=" + $DNSRoot + "," + $DistinguishedName

function OUStructure {
    # Creates the base OU for the rest to be nested underneath. 
    New-ADOrganizationalUnit -Name $DNSRoot -Path $DistinguishedName -ProtectedFromAccidentalDeletion $True -Description "Non-default AD objects go here. Made by PS script."
     # This is where you specify the OU structure you want to use. Eventually this will be changed to support CSV input. 
    $ous = @{
        ouA = @{name = "Users"; path = "$OUPath"; protect = $True; description = "All user accounts should go in here. Made by PS script.";};
        ouB = @{name = "Computers"; path = "$OUPath"; protect = $True; description = "All Computer objects should go here. Made by PS script.";};
        ouC = @{name = "Groups"; path = "$OUPath"; protect = $True; description = "All security groups go here. Made by PS script.";};
        ouD = @{name = "StandardUsers"; path = "OU=Users,$OUPath"; protect = $True; description = "Standard domain user accounts go here. Made by PS script.";};
        ouE = @{name = "AdminUsers"; path = "OU=Users,$OUPath"; protect = $True; description = "Domain admins and other ADM users go here. Made by PS script.";};
        ouF = @{name = "ServiceAccounts"; path = "OU=Users,$OUPath"; protect = $True; description = "Accounts for different services go here. Made by PS script.";};
        ouG = @{name = "Workstations"; path = "OU=Computers,$OUPath"; protect = $True; description = "All workstation computers should go here. Made by PS script.";};
        ouH = @{name = "Servers"; path = "OU=Computers,$OUPath"; protect = $True; description = "All server systems should go here. Made by PS script.";};
        ouI = @{name = "Other"; path = "OU=Computers,$OUPath"; protect = $True; description = "Other systems should go here. Made by PS script.";};
        ouJ = @{name = "InformationTechnology"; path = "OU=Groups,$OUPath"; protect = $True; description = "IT Security Groups. Made by PS script.";};
    }
    Foreach ($ou in $ous.keys) 
    {
        $selected_ou = $ous.$ou
        New-ADOrganizationalUnit -Name $selected_ou.name -Path $selected_ou.path -ProtectedFromAccidentalDeletion $selected_ou.protect -Description $selected_ou.description
    }
}

function securitygroups {
    # This is the OU where the groups should be saved to. 
    $GroupPath = "OU=Groups,$OUPath"
    # This is where you specify your security groups. Eventually this will be changed to support CSV input. 
    $groups = @{
        group1 = @{name = "Human Resources"; samname = "humanresources"; description = "Human Resources Group. Made by PS script."; path = "$GroupPath";};
        group2 = @{name = "Sales"; samname = "sales"; description = "Sales Group. Made by PS script."; path = "$GroupPath";};
        group3 = @{name = "Marketing"; samname = "marketing"; description = "Marketing Group. Made by PS script."; path = "$GroupPath";};
        group4 = @{name = "Managmnet"; samname = "managmnet"; description = "Managment Group. Made by PS script."; path = "$GroupPath";};
        group5 = @{name = "Server Admin"; samname = "serveradmin"; description = "Server Admin Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
        group6 = @{name = "Workstation Admin"; samname = "workstationadmin"; description = "Workstation Admin Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
        group7 = @{name = "Help Desk"; samname = "helpdesk"; description = "Help Desk Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
        group8 = @{name = "System Administrators"; samname = "systemadministrators"; description = "System Administrators Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
    }
    ForEach ($hashtable in $groups.Keys)
    {
        $selected_hashtable = $groups.$hashtable
        New-ADGroup -Name $selected_hashtable.name -SamAccountName $selected_hashtable.samname -GroupCategory Security -GroupScope Global -DisplayName $selected_hashtable.name -Description $selected_hashtable.description -Path $selected_hashtable.path
    }
}


# Add Users
# Create Loging GPOs

OUStructure
securitygroups