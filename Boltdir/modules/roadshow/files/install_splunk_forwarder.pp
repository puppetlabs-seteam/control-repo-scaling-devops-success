# Bolt plan to install a splunk forwarder
plan tools::install_splunk_forwarder(
  TargetSpec $nodes,
  String[1] $splunk_server='splunk.example.com',
){
  apply_prep($nodes)

  apply($nodes) {
    class { '::splunk::params':
      server => $splunk_server,
    }

    if($facts['kernel'] == 'Windows') {
      class { '::splunk::forwarder':
        package_provider => 'chocolatey',
        package_name     => 'splunk-universalforwarder',
        secret_file      => "C:\\ProgramData\\splunk_secrets",
        install_options  => [ ],
      }
    }
    else {
      include ::splunk::forwarder
    }
  }
}
