#A Plan to install Bolt Demo items for the 2019 Roadshow
plan roadshow::prep_boltdemo(
  String[1] $branch_name,
  String[1] $demo_host_id = '0',
  String[1] $demo_user = 'puppetinstructor',
  String[1] $source_inventory = 'roadshow/inventory.yaml',
  String[1] $source_student_pem = 'roadshow/student.pem',
  String[1] $source_puppetfile = 'roadshow/Puppetfile',
  String[1] $source_psscript = 'roadshow/open_tcp_port.ps1',
  String[1] $source_psscriptmeta = 'roadshow/open_tcp_port.json',
) {
  $demo_host     = "${branch_name}win${demo_host_id}.classroom.puppet.com"
  $demo_userdir  = "C:\\Users\\${demo_user}"
  $demo_boltdir  = "C:\\Users\\${demo_user}\\Boltdir"
  $demo_taskdir  = "${demo_boltdir}\\modules\\tools\\tasks"
  $demo_plandir  = "${demo_boltdir}\\modules\\tools\\plans"
  $demo_filesdir = "${demo_boltdir}\\modules\\tools\\files"

  # Install Bolt Binaries
  run_command('choco install puppet-bolt', $demo_host, "Installing Bolt binaries on ${demo_host}")

  # Create directory structure for the demo user
  run_command("mkdir -Force -p ${demo_plandir}", $demo_host, "Creating Boltdir for ${demo_user} account on ${demo_host}")
  run_command("mkdir -Force -p ${demo_taskdir}", $demo_host, "Creating Boltdir for ${demo_user} account on ${demo_host}")
  run_command("mkdir -Force -p ${demo_filesdir}", $demo_host, "Creating files directory for ${demo_user} account on ${demo_host}")

  # Upload a VS Code workspace for better demoing
  upload_file('roadshow/boltdemo.code-workspace', $demo_userdir, $demo_host, "Uploading VS Code workspace to ${demo_host} into ${demo_userdir}")

  # Upload inventory.yaml, student.pem, Puppetfile and install_splunk_fowarder paln to the demo host Boltdir
  upload_file($source_inventory, $demo_boltdir, $demo_host, "Uploading inventory.yaml to ${demo_host}")
  upload_file($source_student_pem, $demo_boltdir, $demo_host, "Uploading student.pem to ${demo_host}")
  upload_file($source_puppetfile, $demo_boltdir, $demo_host, "Uploading Puppetfile to ${demo_host}")

  # Upload standalone tasks
  upload_file($source_psscript, $demo_boltdir, $demo_host, "Uploading ${source_psscript} to ${demo_host} into ${demo_boltdir}")
  upload_file($source_psscript, $demo_taskdir, $demo_host, "Uploading ${source_psscript} to ${demo_host} into ${demo_taskdir}")
  upload_file($source_psscriptmeta, $demo_taskdir, $demo_host, "Uploading ${source_psscriptmeta} to ${demo_host} into ${demo_taskdir}")

  # Upload files required by splunk_qd for installing add-ons on Server and Linux Forwarders
  upload_file('roadshow/puppet-report-viewer_151.tgz', $demo_filesdir, $demo_host, "Uploading puppet-report-viewer to ${demo_host}")
  upload_file('roadshow/puppet-tasks-actionable-alerts-for-splunk_101.tgz', $demo_filesdir, $demo_host, "Uploading puppet-tasks-actionable-alerts-for-splunk to ${demo_host}")
  upload_file('roadshow/splunk-add-on-for-unix-and-linux_602.tgz', $demo_filesdir, $demo_host, "Uploading splunk-add-on-for-unix-and-linux to ${demo_host}")
  upload_file('roadshow/splunk-app-for-unix-and-linux_525.tgz', $demo_filesdir, $demo_host, "Uploading splunk-app-for-unix-and-linux to ${demo_host}")

  # Install modules in Puppetfile on demo host
  run_command('bolt puppetfile install', $demo_host, "Installing Puppetfile for ${demo_user} on ${demo_host}")
}
