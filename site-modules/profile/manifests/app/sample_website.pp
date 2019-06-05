# @summary This profile installs a sample website
class profile::app::sample_website {

  case $::kernel {
    'windows': {
      class{ '::profile::app::sample_website::windows':
        webserver_port => 8123,
      }
    }
    'Linux':   { include profile::app::sample_website::linux }
    default:   {
      fail('Unsupported kernel detected')
    }
  }

}
