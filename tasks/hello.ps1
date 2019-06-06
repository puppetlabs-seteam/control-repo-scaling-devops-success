# hello.ps1
$hostname = [System.Net.Dns]::GetHostByName((hostname)).HostName
write-host "Hello and Welcome to ${hostname}. I see you are running as user '${env:USERNAME}'."