class profile::platform::baseline::linux::service_user{

  user{ 'tom_local':
    ensure   => present,
    uid      => 10001,
    gid      => 10001,
    password => '$6$KzLPJe2tmDUcqwah$tOWJuDcgir1vi4M9btVkg/NjJpVBbxs9Q7sZ97wBC3Z5lM4MN4sjFOnxfafJ93NhLgNsINHao0SGaLJhkVasg0',
    groups   => ['wheel'],
  }

}
