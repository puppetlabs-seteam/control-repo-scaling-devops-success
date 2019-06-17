#A Plan to install Bolt Demo items for the 2019 Roadshow
plan roadshow::prep_boltdemo(
  String[1] $branch_name,
  String[1] $demo_host_id = '0',
  String[1] $demo_user = 'puppetinstructor',
  String[1] $demo_pass = '@Pupp3t1abs',
  String[1] $source_inventory = 'roadshow/inventory.yaml',
  String[1] $source_student_pem = 'roadshow/student.pem',
  String[1] $source_puppetfile = 'roadshow/Puppetfile',
  String[1] $source_isfplan = 'roadshow/install_splunk_forwarder.pp',
  String[1] $source_psscript = 'roadshow/open_tcp_port.ps1',
  String[1] $source_psscriptmeta = 'roadshow/open_tcp_port.json',
  Integer $max_hosts = 10,
  Bool $reboot_windows_hosts = false,
) {
  # lint:ignore:140chars
  $demo_host = "${branch_name}win${demo_host_id}.classroom.puppet.com"
  $demo_userdir = "C:\\Users\\${demo_user}"
  $demo_boltdir = "C:\\Users\\${demo_user}\\Boltdir"
  $demo_taskdir = "${demo_boltdir}\\modules\\tools\\tasks"
  $demo_plandir = "${demo_boltdir}\\modules\\tools\\plans"

  # Install Bolt Binaries
  run_command('choco install puppet-bolt', $demo_host, "Installing Bolt binaries on ${demo_host}")

  # Create directory structure for the demo user
  run_command("mkdir -Force -p ${demo_plandir}", $demo_host, "Creating Boltdir for ${demo_user} account on ${demo_host}")
  run_command("mkdir -Force -p ${demo_taskdir}", $demo_host, "Creating Boltdir for ${demo_user} account on ${demo_host}")

  # Upload inventory.yaml, student.pem, Puppetfile and install_splunk_fowarder paln to the demo host Boltdir
  run_script('roadshow/retrieve_branch_info.ps1', $demo_host, "Running inventory prep script on ${demo_host}", 'arguments' => [$max_hosts,$branch_name,"${demo_boltdir}\\"])
  upload_file($source_puppetfile, $demo_boltdir, $demo_host, "Uploading Puppetfile to ${demo_host}")
  upload_file($source_psscript, $demo_boltdir, $demo_host, "Uploading ${source_psscript} to ${demo_host} into ${demo_boltdir}")
  upload_file($source_psscript, $demo_taskdir, $demo_host, "Uploading ${source_psscript} to ${demo_host} into ${demo_taskdir}")
  upload_file($source_psscriptmeta, $demo_taskdir, $demo_host, "Uploading ${source_psscriptmeta} to ${demo_host} into ${demo_taskdir}")
  upload_file('roadshow/boltdemo.code-workspace', "${demo_userdir}\\Documents", $demo_host, "Uploading VS Code workspace to ${demo_host} into ${demo_userdir}")
  upload_file($source_isfplan, $demo_plandir, $demo_host, "Uploading Bolt plan tools::install_splunk_forwarder for ${demo_user} to ${demo_host}")

  # Install Puppetfile on demo host
  run_command('bolt puppetfile install', $demo_host, "Installing Puppetfile for ${demo_user} on ${demo_host}")

  #Activate Firewalls on Windows nodes
  run_command('bolt command run \'Set-Service "MpsSvc" -StartupType Automatic\' -n allwindows', $demo_host, 'Enabling Firewall on Windows Hosts')
  run_command('bolt command run \'netsh advfirewall firewall add rule name="Open Port 5985" dir=in action=allow protocol=TCP localport=5985\' -n allwindows', $demo_host, 'Opening Firewall Port 5985 on Windows Hosts')
  run_command('bolt command run \'netsh advfirewall firewall add rule name="Open Port 5986" dir=in action=allow protocol=TCP localport=5986\' -n allwindows', $demo_host, 'Opening Firewall Port 5986 on Windows Hosts')
  run_command('bolt command run \'Set-Service -Name "MpsSvc" -Status Running\' -n allwindows', $demo_host, 'Starting Firewall Service on Windows Hosts')

  if ($reboot_windows_hosts == true) {
    runcommand('bolt command run \'Shutdown /r /t 0\' -n allwindows', $demo_host, 'Restarting Windows hosts.')
  }

  # lint:endignore
}
