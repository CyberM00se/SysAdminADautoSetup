#region demo Header
#endregion

#region install DHCP
#Find the DHCP Server Name
Get-WindowsFeature | Where-Object Name -like "*DHCP*"

#Intall it with management tools
Install-WindowsFeature DHCP -IncludeManagementTools

#endregion

#region create Security Groups

#Current Groups
($([ADSI]"WinNT://$env:COMPUTERNAME").Children | Where-Object SchemaClassName -eq 'group').name

#Use netsh to create new ones
netsh dhcp add securitygroups

#verify group creation
($([ADSI]"WinNT://$env:COMPUTERNAME").Children | Where-Object SchemaClassName -eq 'group').name

#Restart the DHCP server service
Restart-Service dhcpserver

#endregion

#region Authorize
Get-DhcpServerInDC

#Get IP for the dhcp server
Get-NetIPAddress -InterfaceAlias Ethernet -AddressFamily IPv4
$LocalFQDN = (Resolve-DnsName $env:COMPUTERNAME | Where-Object Type -eq 'A').Name

#Authorize the server
Add-DhcpServerInDC -DnsName $LocalFQDN -IPAddress $LocalIP

#Verify
Get-DhcpServerInDC
#endregion