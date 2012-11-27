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

  if $::nfs::client {
  }

  if $::nfs::server {
    file { $::nfs::config_file:
      ensure => directory,
    }
  }
}

