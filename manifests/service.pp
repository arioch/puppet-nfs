# = Class nfs
#
class nfs::service {
  if $::nfs::server {
    service { $::nfs::service_name:
      ensure    => $::nfs::service_ensure,
      enable    => $::nfs::service_enable,
      hasstatus => $::nfs::service_hasstatus,
      require   => Class['::nfs::config'];
    }
  }
}

