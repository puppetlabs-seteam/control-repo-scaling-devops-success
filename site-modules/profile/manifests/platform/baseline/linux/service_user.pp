class profile::platform::baseline::linux::service_user{

  group { 'admins_local':
    ensure => present,
    gid    => 10000,
  }

  user{ 'tom_local':
    ensure   => present,
    uid      => 10001,
    gid      => 10000,
    password => '$6$KzLPJe2tmDUcqwah$tOWJuDcgir1vi4M9btVkg/NjJpVBbxs9Q7sZ97wBC3Z5lM4MN4sjFOnxfafJ93NhLgNsINHao0SGaLJhkVasg0',
    groups   => ['wheel'],
  }

  user{ 'abir_local':
    ensure   => present,
    uid      => 10002,
    gid      => 10000,
    password => '6$de.E79ZLrAyCtS1I$XydX5VUsCIJiPrsOfh2U9ceW1E56aNDJQnfhGjDG2L54J4AIgqqBtVyG2AteCIYcGBi7Y9PvUpbzO87MeJrvk1',
    groups   => ['wheel'],
  }

}
