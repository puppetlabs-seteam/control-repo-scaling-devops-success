#Set a timeserver registry key
#Windows default is: time.windows.com,0x9
[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True)]
 [String]
  $timeservers
  )
Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Parameters
Set-ItemProperty . NtpServer $timeservers
Set-ItemProperty . Type "NTP"