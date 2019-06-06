[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True)]
 [String]
  $port
)

netsh advfirewall firewall add rule name="Open Port ${port}" dir=in action=allow protocol=TCP localport=$port