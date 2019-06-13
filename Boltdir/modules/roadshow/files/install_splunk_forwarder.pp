# Bolt plan to install a splunk forwarder
plan tools::install_splunk_forwarder(
  TargetSpec $nodes,
  String[1] $splunk_server='',
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
#        install_options  => [
#          'INSTALLDIR=C:\\Program Files\\SplunkUniversalForwarder',
#          'AGREETOLICENSE=YES',
#          'LAUNCHSPLUNK=0',
#          'SERVICESTARTTYPE=auto',
#          'WINEVENTLOG_APP_ENABLE=1',
#          'WINEVENTLOG_SEC_ENABLE=1',
#          'WINEVENTLOG_SYS_ENABLE=1',
#          'WINEVENTLOG_FWD_ENABLE=1',
#          'WINEVENTLOG_SET_ENABLE=1',
#          'ENABLEADMON=1',
#        ]
      }
    }
    else {
      include ::splunk::forwarder
    }
  }
}
