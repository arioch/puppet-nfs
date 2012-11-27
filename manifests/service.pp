# = Class nfs
#
class nfs::service {
  if $::nfs::server {

    if $::osfamily == 'RedHat' {

      service { 'rpcbind':
        ensure    => $::nfs::service_ensure,
        enable    => $::nfs::service_enable,
        hasstatus => $::nfs::service_hasstatus,
        require   => Class['::nfs::config'];
      }

      service { $::nfs::service_name:
        ensure    => $::nfs::service_ensure,
        enable    => $::nfs::service_enable,
        hasstatus => $::nfs::service_hasstatus,
        require   => [ Class['::nfs::config'], Service['rpcbind'], ];
      }

    } else {

      service { $::nfs::service_name:
        ensure    => $::nfs::service_ensure,
        enable    => $::nfs::service_enable,
        hasstatus => $::nfs::service_hasstatus,
        require   => Class['::nfs::config'];
      }

    }
  }
}

