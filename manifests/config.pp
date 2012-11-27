# = Class nfs::config
#
class nfs::config {
  File {
    ensure  => present,
    require => Class['::nfs::install'],
    notify  => Service[$::nfs::service_name],
    owner   => $::nfs::config_user,
    group   => $::nfs::config_group,
  }

  if $::nfs::server {
    concat { $::nfs::config_file:
      group => $::nfs::config_group,
      mode  => $::nfs::config_mode,
      owner => $::nfs::config_user,
    }

    concat::fragment { 'export_header':
      target  => $::nfs::config_file,
      content => "# Managed by Puppet\n\n",
      order   => 01,
    }
  }
}

