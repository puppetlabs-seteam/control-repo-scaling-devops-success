# Hello.ps1
write-host "Hello and Welcome to " -NoNewline
write-host ([System.Net.Dns]::GetHostByName((hostname)).HostName) -ForegroundColor Yellow -NoNewline
write-host ". I see you are running as user: " -NoNewline
write-host "${env:USERNAME}" -ForegroundColor Yellow