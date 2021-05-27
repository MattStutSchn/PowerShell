
az login
az account set --subscription "Production CSP @ Bright Skies GmbH"

#ANMELDEN AN AZURE
Connect-AzAccount
Connect-AzAccount -UseDeviceAuthentication

#POWERSHELL REMOTE
$serverwin = "Exegol"
$userwin = "Schneider\Administrator"
Enter-PSSession -ComputerName $serverwin -Credential $user

#SSH REMOTE VIA ENTER-PSSESSION
$serverlin = "exegol"
$userlin = "root"
Enter-PSSession -HostName $serverlin"@"$userlin

#ANZEIGE UND WECHSEL DER SUBSC.
Get-AzSubscription
get-AzContext


#OS DISK ERWEITERN
az vm list --resource-group WAKONFIPROD001 --name wakonfiprod01
az vm deallocate --resource-group WAKONFIPROD001 --name wakonfiprod01
az disk list --resource-group WAKONFIPROD001 --query '[*].{Name:name,Gb:diskSizeGb,Tier:accountType}' --output table
az disk update --resource-group WAKONFIPROD001 --name wakonfiprod01_OsDisk_1_d44e73489bd24031abe0cd7d905fa780 --size-gb 256
az vm start --resource-group WAKONFIPROD001 --name wakonfiprod01


# AKS KLUSTER VERWALTEN
# > ANNMELDUNG
az aks get-credentials --resource-group gksstagprod001 --name gksstagprod01

# > REBOOT POD
kubectl scale deployment schneider-stage --replicas=0
kubectl scale deployment schneider-stage --replicas=1


# > ALLE PODS ANZEIGEN
kubectl get pods --all-namespaces

# > BASH ANMELDUNG AM POD
kubectl exec -it schneider-stage-67946dcf4f-xzv5m /bin/bash
kubectl exec schneider-stage-577b46f88b-lj5t9 -- ls /


# > GET CPU LOAD
kubectl exec schneider-stage-67946dcf4f-xzv5m -- cat /sys/fs/cgroup/cpu/cpuacct.usage_percpu
kubectl exec schneider-stage-577b46f88b-lj5t9 -- cat /sys/fs/cgroup/memory/memory.usage_in_bytes
 

# > ALLE PODS INFOS ANZEIGEN 
kubectl get pods -o wide

# > PODS ALLE INFORMATIONEN
kubectl describe pod schneider-prod-5c999f545d-w52hv
kubectl describe pod schneider-stage-67946dcf4f-xzv5m
kubectl describe pod schneider-nginx-ingress-controller-d648667df-56hsl
kubectl describe pod schneider-nginx-ingress-controller-d648667df-lt7vw
kubectl describe pod schneider-nginx-ingress-default-backend-77d89bb568-mdr9x

kubectl utilization requests schneider-prod-5c999f545d-w52hv

#POD RESSOURCE INFORMATION
kubectl top pod schneider-prod-5c999f545d-w52hv --namespace=default
kubectl top pod schneider-stage-67946dcf4f-xzv5m --namespace=default



kubectl exec schneider-nginx-ingress-controller-d648667df-56hsl -- ls /
kubectl exec schneider-stage-9975cff77-r6w5d -- ls /var/www/html
kubectl exec schneider-stage-9975cff77-tkrb9 -- cat /var/www/html/config.php
kubectl exec schneider-stage-577b46f88b-lj5t9 -- ping proxysql


Start-Process kubectl 'exec -it schneider-stage-9975cff77-tkrb9 -n default -- bash'

https://schweigerstechblog.de/passwort-sicher-in-powershell-scripts-speichern/
### Step 1: Creating Securestring encrypted with AES Key
$AESKey = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)
$AESKey | Out-File .\Desktop\aes.key
 
$password = Read-Host "Enter Password:" -AsSecureString
$password | ConvertFrom-SecureString -Key $AESKey | Out-File .\Desktop\password.txt
 
 
### Step 2: Using Securestring and AES Key in Scripts
$username = "Schneider\Stutzke_Matthias"
$AESKey = Get-Content .\Desktop\aes.key
$password = Get-Content .\Desktop\password.txt | ConvertTo-SecureString -Key $AESKey
$credentials = New-Object System.Management.Automation.PSCredential (“$username”, $password)


#PowerShell Invoke-WebRequest - Parse and scrape a web page
https://4sysops.com/archives/powershell-invoke-webrequest-parse-and-scrape-a-web-page/

#REGISTER PSREPOSITROY https://copdips.com/2018/05/setting-up-powershell-gallery-and-nuget-gallery-for-powershell.html
#PSGallery 
Register-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted

#NUGET
Register-PackageSource -Name Nuget -Location "http://www.nuget.org/api/v2" –ProviderName Nuget -Trusted

#INSTALL FROM NUGET
Install-Package -name Microsoft.PowerShell.Security -Scope CurrentUser -SkipDependencies

#CHANGE PS REPOSITORY
Set-PSRepository -Name "myInternalSource" -SourceLocation 'https://someNuGetUrl.com/api/v2' -PublishLocation 'https://someNuGetUrl.com/api/v2/packages'


#REMOTE VIA KEY
$server = "Zuse"
$username = "Schneider\Stutzke_Matthias"
$AESKey = Get-Content .\Desktop\aes.key
$password = Get-Content .\Desktop\password.txt | ConvertTo-SecureString -Key $AESKey
$credentials = New-Object System.Management.Automation.PSCredential ($username, $password)
Enter-PSSession -ComputerName $server -Credential $credentials

Enter-PSSession -ComputerName Shefex-APP1 -Credential Schneider\Administrator

#GET DRIVE LETTER
$Drive = Get-CimInstance -ClassName Win32_Volume #-Filter "DriveLetter = 'C:'"
$Drive | Select-Object -Property SystemName, Label, DriveLetter


