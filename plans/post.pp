plan profile::post(
  TargetSpec $nodes,
  ) {
  # start puppet
  run_task('service', $nodes,'Starting Puppet Service',
  'name'     => 'puppet',
  'action'   => 'start')
}

