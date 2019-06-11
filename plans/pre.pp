plan profile::pre(
  TargetSpec $nodes,
  ) {
  # stop puppet
  run_task('service', $nodes,'Stopping Puppet Service',
  'name'     => 'puppet',
  'action'   => 'stop')

  # Break ntp
  run_task('facts', $nodes, '_catch_errors' => true).reduce([]) |$info, $r| {
    if ($r.ok) {
      if ($r[os][name] == 'windows') {
        $cmd = "Set-Location HKLM:\\SYSTEM\\CurrentControlSet\\services\\W32Time\\Parameters; Set-ItemProperty . NtpServer 'bad values'; Set-ItemProperty . Type 'NTP'"
      } else {
        $cmd = 'rm -rf /etc/ntp.conf'
      }
      run_command($cmd, $r.target.name,'Breaking NTP')
    }
  }
}

