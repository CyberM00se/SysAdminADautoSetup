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
    $ous = [ordered]@{
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
    Foreach ($ou in $ous.Keys) 
    {
        $selected_ou = $ous.$ou
        New-ADOrganizationalUnit -Name $selected_ou.name -Path $selected_ou.path -ProtectedFromAccidentalDeletion $selected_ou.protect -Description $selected_ou.description
    }
}

function securitygroups {
    # This is the OU where the groups should be saved to. 
    $GroupPath = "OU=Groups,$OUPath"
    # This is where you specify your security groups. Eventually this will be changed to support CSV input. 
    $groups = [ordered]@{
        group1 = @{name = "Human Resources"; samname = "humanresources"; description = "Human Resources Group. Made by PS script."; path = "$GroupPath";};
        group2 = @{name = "Sales"; samname = "sales"; description = "Sales Group. Made by PS script."; path = "$GroupPath";};
        group3 = @{name = "Marketing"; samname = "marketing"; description = "Marketing Group. Made by PS script."; path = "$GroupPath";};
        group4 = @{name = "Managmnet"; samname = "managmnet"; description = "Managment Group. Made by PS script."; path = "$GroupPath";};
        group5 = @{name = "Server Admin"; samname = "serveradmin"; description = "Server Admin Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
        group6 = @{name = "Workstation Admin"; samname = "workstationadmin"; description = "Workstation Admin Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
        group7 = @{name = "Help Desk"; samname = "helpdesk"; description = "Help Desk Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
        group8 = @{name = "System Administrators"; samname = "systemadministrators"; description = "System Administrators Group. Made by PS script."; path = "OU=InformationTechnology,$GroupPath";};
    }
    ForEach ($group in $groups.Keys)
    {
        $selected_group = $groups.$group
        New-ADGroup -Name $selected_group.name -SamAccountName $selected_group.samname -GroupCategory Security -GroupScope Global -DisplayName $selected_group.name -Description $selected_group.description -Path $selected_group.path
    }
}

function addusers {
    $defaultPass = "ChangeMe!"  # The default password for all users made with this script. 
    $UserPath ="OU=Users,$OUPath"  # Where all user accounts should be stored in the OU structure.
    $userlist = [ordered]@{
        user1 = @{uname = "dnavarro-sysadm"; dname = "Dylan SysAdmin"; email = "mail@corp.net"; description = "Sys Admin Account"; path = "OU=AdminUsers,$UserPath"; groups = @{group0 = "serveradmin";group2 = "systemadministrators";};};
        user2 = @{uname = "dnavarro-hdt"; dname = "Dylan Help Deks"; email = "mail@corp.net"; description = "Help Desk Account"; path = "OU=AdminUsers,$UserPath"; groups = @{group0 = "workstationadmin";group2 = "helpdesk";};};
        user3 = @{uname = "dnavarro-marketing"; dname = "Marketing Dylan"; email = "mail@corp.net"; description = "Marketing Person"; path = "OU=StandardUsers,$UserPath"; groups = @{group0 = "marketing";};};
        user4 = @{uname = "dnavarro-sales"; dname = "Sales Dylan"; email = "mail@corp.net"; description = "Sales Person"; path = "OU=StandardUsers,$UserPath"; groups = @{group0 = "sales";};};
        user5 = @{uname = "dnavarro-hr"; dname = "HR Dylan"; email = "mail@corp.net"; description = "HR Person"; path = "OU=StandardUsers,$UserPath"; groups = @{group0 = "humanresources";};};
        user8 = @{uname = "dnavarro-man"; dname = "Manager Dylan"; email = "mail@corp.net"; description = "Manager Person"; path = "OU=StandardUsers,$UserPath"; groups = @{group0 = "managmnet";};};
    }
    ForEach ($user in $userlist.Keys) # Just changed all .Keys to capital k in case that breaks stuff.
    {
        $selected_user = $userlist.$user
        # -AccountPassword (ConvertTo-SecureString -AsPlainText $defaultPass -Force)
        New-ADUser -ChangePasswordAtLogon $True -Enabled $True -SamAccountName $selected_user.uname -Name $selected_user.uname -DisplayName $selected_user.dname -EmailAddress $selected_user.email -Description $selected_user.description -Path $selected_user.path -AccountPassword (ConvertTo-SecureString -AsPlainText $defaultPass -Force)
        Foreach ($group in $selected_user.groups.Keys)
        {
            $selected_group = $selected_user.groups.$group
            Add-ADGroupMember -Identity  $selected_group -Members $selected_user.uname
        }
    }
}

function dnsreverslookupzone {
    $ip = (Get-NetIPAddress -InterfaceAlias "Ethernet0" -AddressFamily IPv4 | Select-Object IPAddress).IPAddress
    $subnet = (Get-NetIPAddress -InterfaceAlias "Ethernet0" -AddressFamily IPv4 | Select-Object PrefixLength).PrefixLength
    $iplen = $ip.Length - 1
    $netID = $ip.Substring(0, $iplen) + "0/$subnet"
    Add-DnsServerPrimaryZone -NetworkID $netID -ReplicationScope "Forest"
}

OUStructure
securitygroups
addusers
dnsreverslookupzone