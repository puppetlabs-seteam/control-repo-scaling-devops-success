# Bolt plan to install a splunk forwarder
plan tools::install_splunk_forwarder(
  TargetSpec $nodes,
  String[1] $splunk_server='',
){
  apply_prep($nodes)

  apply($nodes) {
    include ::splunk
    class { '::splunk::params':
      server => $splunk_server,
    }

    class { '::splunk::forwarder':
      package_ensure => 'latest',
    }
  }
}
