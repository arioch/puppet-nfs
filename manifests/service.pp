# == Class nfs
#
class nfs::service {
  if $::nfs::server {
    Service {
      require => Class['::nfs::config'],
    }

    service { $::nfs::service_rpc:
      ensure    => $::nfs::service_ensure,
      enable    => $::nfs::service_enable,
      hasstatus => $::nfs::service_hasstatus;
    }

    service { $::nfs::service_name:
      ensure    => $::nfs::service_ensure,
      enable    => $::nfs::service_enable,
      hasstatus => $::nfs::service_hasstatus,
      require   => Service[$::nfs::service_rpc];
    }


  }
  case $::operatingsystem {
    centos, redhat: {
      service { $::nfs::service_idmap:
        ensure    => $::nfs::service_ensure,
        enable    => $::nfs::service_enable,
        hasstatus => $::nfs::service_hasstatus;
      }
    }

    debian: {
      notify {'rpc.idmapd might need to be configured': }
    }
  }


}


