#region demo Header
#endregion

#region install DHCP
#Find the DHCP Server Name
Get-WindowsFeature | Where-Object Name -like "*DHCP*"

Write-Output "Installing DHCP with Managmenet Tools"
#Intall it with management tools
Install-WindowsFeature DHCP -IncludeManagementTools

#endregion

#region create Security Groups

Write-Output "Creating Security Groups"

#Create a new security group
netsh dhcp add securitygroups

#Restart the DHCP server service
Write-Output "Restarting DHCP Service"
Restart-Service dhcpserver

#endregion

#region Add Scope

#add input section here for name of scope
#add input section here for start and end range

Add-DhcpServerv4Scope -ComputerName $env:COMPUTERNAME -Name "testDhcpscope" -StartRange 10.0.1.10 -EndRange 10.0.2.100 -SubnetMask 255.255.255.0 -LeaseDuration 8:0:0:0

#get the default gateway
$myDefaultGateway = Get-NetIPConfiguration | foreach IPv4DefaultGateway

#get the domain name
$myDomainName = (Get-WmiObject Win32_ComputerSystem).Domain

#get the local machines Ip address
$localIP = (Get-NetIPAddress -InterfaceAlias Ethernet -AddressFamily IPv4).IPAddress

#set the dhcp settings
Set-DhcpServerv4Optionvalue -computername $env:COMPUTERNAME -Router $myDefaultGateway -dns 127.0.0.1 -DnsDomain $myDomainName

#authorize the dhcp server for ad network
Add-DhcpServerInDC $env:COMPUTERNAME $localIP

#endregion