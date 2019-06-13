#A Plan to install Bolt Demo items for the 2019 Roadshow
plan roadshow::prep_boltdemo(
  String[1] $branch_name,
  String[1] $demo_host_id = '0',
  String[1] $demo_user = 'puppetinstructor',
  String[1] $source_inventory = 'roadshow/inventory.yaml',
  String[1] $source_student_pem = 'roadshow/student.pem',
  String[1] $source_puppetfile = 'roadshow/Puppetfile',
  String[1] $source_isfplan = 'roadshow/install_splunk_forwarder.pp',
) {
  $demo_host = "${branch_name}win${demo_host_id}.classroom.puppet.com"
  $demo_userdir = "C:\\Users\\${demo_user}"
  $demo_boltdir = "C:\\Users\\${demo_user}\\Boltdir"
  $demo_plandir = "${demo_boltdir}\\modules\\tools\\plans"

  # Install Bolt Binaries
  run_command('choco install puppet-bolt', $demo_host, "Installing Bolt binaries on ${demo_host}")

  # Create directory structure for the demo user
  run_command("mkdir -Force -p ${demo_plandir}", $demo_host, "Creating Boltdir for ${demo_user} account on ${demo_host}")

  # Upload inventory.yaml, student.pem, Puppetfile and install_splunk_fowarder paln to the demo host Boltdir
  upload_file($source_inventory, $demo_boltdir, $demo_host, "Uploading inventory.yaml to ${demo_host}")
  upload_file($source_student_pem, $demo_boltdir, $demo_host, "Uploading student.pem to ${demo_host}")
  upload_file($source_puppetfile, $demo_boltdir, $demo_host, "Uploading Puppetfile to ${demo_host}")
  upload_file($source_isfplan, "${demo_plandir}", $demo_host, "Uploading Bolt plan tools::install_splunk_forwarder for ${demo_user} to ${demo_host}")

  # Install Puppetfile on demo host
  run_command('bolt puppetfile install', $demo_host, "Installing Puppetfile for ${demo_user} on ${demo_host}")

}
