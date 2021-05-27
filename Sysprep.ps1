#3x APP: 4 CPU / 20 GB RAM / HHD1 Std / HDD2 40GB E:
#DTP1: 4CPU / 16 GB RAM / HDD1 Std / HDD2 40GB E: / HDD3 8TB N:
#FS1: 4CPU / 8 GB RAM / HDD1 Std / HDD2 120GB L: / HDD3 130GB M:
#DB1: Clone

#192.168.184.
#100 -> DB1
#101 -> APP1
#102 -> APP2
#103 -> APP3
#104 -> FS1
#105 -> DTP1

#VAR
$group ="Administrators"
$user = "Schneider\Stibo-1"
$key2016 =
$key2019 = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
$key = $key2019

$ip = "10.128.2.20"
$pf = "22"
$gw = "10.128.3.254"
$if = "Ethernet0"
$dns1 = "10.128.2.1"
$dns2 = "10.128.2.2"
Set-DnsClientServerAddress –InterfaceAlias $if -ServerAddresses ($dns1, $dns2)
New-NetIPAddress -InterfaceAlias $if -AddressFamily IPv4 -IPAddress $ip -PrefixLength $pf -DefaultGateway $gw


#ADD TO DOMAIN
Add-Computer -DomainName schneider-gruppe.net -Credential Schneider\Administrator -Restart -Force



$key = $key2019

#ADD USER TO GROUP
Add-LocalGroupMember -Group $group -Member $user

#WINDOWS KEY + AKTIVIERUNG
slmgr /ipk $key
slmgr /ato

#INIT NEW DISK
Initialize-Disk -Number 1 -PartitionStyle MBR
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter
Format-Volume -DriveLetter E -FileSystem NTFS -Force

#INSTALL CHOCOLATEY
Set-ExecutionPolicy Bypass -Scope Process
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))