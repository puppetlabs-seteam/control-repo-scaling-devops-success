class profile::platform::baseline::linux::service_user{

  group { 'admins_local':
    ensure => present,
    gid    => 10000,
  }

  user{ 'tom_local':
    ensure   => present,
    uid      => 10001,
    gid      => 10000,
    password => '$6$f7ad3f147661c04e$LuY2G7Ka78bBUnpTWOlkfN5ILIEupFGiRQDi..9QV0nDgkRyagcxAtVSXWOOE6Fwe2dK3tAPlYJ.Q.uvfQmGq1',
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
