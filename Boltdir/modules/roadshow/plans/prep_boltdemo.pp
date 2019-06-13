plan roadshow::prep_boltdemo(
  String[1] $branch_name,
  String[1] $demo_host_id = '0',
  String[1] $demo_user = 'puppetinstructor',
  String[1] $source_inventory = 'roadshow/inventory.yaml',
  String[1] $source_student_pem = 'roadshow/student.pem',
) {
  $demo_host = "${branch_name}win${demo_host_id}.classroom.puppet.com"
  $demo_userdir = "C:\\Users\\${demo_user}"
  $demo_boltdir = "C:\\Users\\${demo_user}\\Boltdir"

  # Install Bolt Binaries
  run_command('choco install puppet-bolt', $demo_host, "Installing Bolt binaries on ${demo_host}")

  # Create a Boltdir for the demo user
  run_command("mkdir -Force -p ${demo_boltdir}", $demo_host, "Creating Boltdir for ${demo_user} account on ${demo_host}")

  # Upload inventory.yaml and student.pem to the demo host
  upload_file($source_inventory, $demo_boltdir, $demo_host, "Uploading inventory.yaml to ${demo_host}")
  upload_file($source_student_pem, $demo_boltdir, $demo_host, "Uploading student.pem to ${demo_host}")

  # Create puppetfile on the demo host

  # Create Plan on Windows Host

}
