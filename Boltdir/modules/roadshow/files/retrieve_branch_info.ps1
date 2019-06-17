[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True)] 
  [Int] $MaxHosts,
  [Parameter(Mandatory = $True)] 
  [String] $Branch,
  [Parameter(Mandatory = $False)] 
  [String] $SavePath = ".\"
)

function getHostData ($idx, $Branch, $SavePath) {
    # Start a web session
    $uri = "https://" + $Branch + ".classroom.puppet.com/"
    $access = Invoke-WebRequest -uri $uri -SessionVariable session
    
    # Set login info for clientX
    $form = $access.forms[0]
    $form.fields["email"] = "client" + $idx + "@puppet.com"

    #Login
    Try {
        $loginResponse = Invoke-WebRequest -uri ($uri + $form.Action) -WebSession $session -Method post -Body $form.fields
        $result = @{
            StatusCode = $loginResponse.StatusCode; 
            LinuxHostname = "";
            WinHostname = "";
            RDPPassword = "";
            Valid = $false;
        }
    } 
    Catch {
        #return on failed login
        $result = @{ StatusCode = $loginResponse.StatusCode; Valid = $false }
        return $result
    }

    # On login success, get required info
    if ($loginResponse.StatusCode -eq 200) {
        #Download Student PEM & PPK on first host only
        if ($idx -eq 0) {
            Invoke-WebRequest -uri ($uri + "download/student.pem") -WebSession $session | Select-Object -ExpandProperty Content  | Out-File ($SavePath + "student.pem")
            Invoke-WebRequest -uri ($uri + "download/private_key.ppk") -WebSession $session | Select-Object -ExpandProperty Content  | Out-File ($SavePath + "private_key.ppk")
        }
        $result.LinuxHostname = $Branch + "nix" + $idx + ".classroom.puppet.com"
        $result.WinHostname = $Branch + "win" + $idx + ".classroom.puppet.com"
        $result.RDPPassword = $loginResponse.ParsedHtml.getElementById("winrdp-passwd").getAttribute("data-clipboard-text")
        $result.Valid = $true
    }
    return $result
}

function testConnect ($h) {
    Try {
        if (Test-Connect $h -Count 2 -Delay 1) {
            return $true
        }
        else {
            return $false
        }
    }
    Catch {
        return $false
    }
}

function createInventoryFile ($inputs, $Branch, $SavePath) {
    $filename = $SavePath + "inventory.yaml"
    $yaml = ""
    $yaml += "groups:`n"
    $yaml += "  - name: master`n"
    $yaml += "    nodes:`n"
    $yaml += "      - " + ($Branch + "-master.classroom.puppet.com") + "`n"
    $yaml += "    config:`n"
    $yaml += "      transport: ssh`n"
    $yaml += "      ssh:`n"
    $yaml += "        host-key-check: false`n"
    $yaml += "        user: centos`n"
    $yaml += "        run-as: root`n"
    $yaml += "        private-key: ~/.ssh/training.pem`n"
    $yaml += "  - name: gitlab`n"
    $yaml += "    nodes:`n"
    $yaml += "      - " + ($Branch + "-gitlab.classroom.puppet.com") + "`n"
    $yaml += "    config:`n"
    $yaml += "      transport: ssh`n"
    $yaml += "      ssh:`n"
    $yaml += "        host-key-check: false`n"
    $yaml += "        user: centos`n"
    $yaml += "        run-as: root`n"
    $yaml += "        private-key: ~/.ssh/training.pem`n"
    $yaml += "  - name: lnxstudents`n"
    $yaml += "    nodes:`n"
    foreach ($h in $inputs) {
        $tc = testConnect($h.LinuxHostname)
        if ($tc -and $null -ne $h.LinuxHostname) {
            $ip = [System.Net.Dns]::GetHostAddresses($h.LinuxHostname)
            $yaml += "      - ${ip}`n"
        }
    }
    $yaml += "    config:`n"
    $yaml += "      transport: ssh`n"
    $yaml += "      ssh:`n"
    $yaml += "        host-key-check: false`n"
    $yaml += "        user: centos`n"
    $yaml += "        run-as: root`n"
    $yaml += "        private-key: Boltdir\\student.pem`n"
    $yaml += "  - name: winstudents`n"
    $yaml += "    nodes:`n"
    foreach ($h in $inputs) {
        $tc = testConnect($h.WinHostname)
        if ($tc -and $null -ne $h.WinHostname) {
            write-host Adding $h.WinHostname $h.Valid $h.RDPPassword
            $yaml += "      - ${ip}`n"
        }
    }
    $yaml += "    config:`n"
    $yaml += "      transport: winrm`n"
    $yaml += "      winrm:`n"
    $yaml += "        user: puppetinstructor`n"
    $yaml += "        password: '@Pupp3t1abs'`n"
    $yaml += "        ssl: false`n"
    $yaml += "  - name: allwindows`n"
    $yaml += "    nodes:`n"
    foreach ($h in $inputs) {
        $tc = testConnect($h.WinHostname)
        if ($tc -and $null -ne $h.WinHostname) {
            $yaml += "      - " + $h.WinHostname + "`n"
        }
    }
    $yaml += "    config:`n"
    $yaml += "      transport: winrm`n"
    $yaml += "      winrm:`n"
    $yaml += "        user: puppetinstructor`n"
    $yaml += "        password: '@Pupp3t1abs'`n"
    $yaml += "        ssl: false`n"
    $yaml += "  - name: alllinux`n"
    $yaml += "    nodes:`n"
    foreach ($h in $inputs) {
        $tc = testConnect($h.LinuxHostname)
        if ($tc -and $null -ne $h.LinuxHostname) {
            $yaml += "      - " + $h.LinuxHostname + "`n"
        }
    }
    $yaml += "    config:`n"
    $yaml += "      transport: ssh`n"
    $yaml += "      ssh:`n"
    $yaml += "        host-key-check: false`n"
    $yaml += "        user: centos`n"
    $yaml += "        run-as: root`n"
    $yaml += "        private-key: Boltdir\\student.pem`n"

    write-host Writing to file $filename
    $yaml | Out-File $filename -Encoding ASCII

}

$firstFailure = $False
$results = @()
for ($idx=0; $idx -le $MaxHosts; $idx++) {
    write-host "Getting Info for hosts: ${idx}"
    $res = getHostData $idx $Branch $SavePath
    $results += $res

    if ($res.StatusCode -ne 200 -and $firstFailure) { break }
    if ($res.StatusCode -ne 200) { $firstFailure= $True }
}

if ($results.length -gt 0) {
    write-host "Creating inventory.yaml"
    createInventoryFile $results $Branch $SavePath
}

