# = Class nfs::install
#
class nfs::install {

  case $::osfamily {
    'RedHat': {
      # Both client and server are installed using
      # a single package on RHEL

      if $::nfs::client or $::nfs::server {
        package { $::nfs::pkg_list_client:
          ensure => $::nfs::pkg_ensure;
        }
      }
    }

    'Debian': {
      # On Debian client and server packages are split.

      if $::nfs::client {
        package { $::nfs::pkg_list_client:
          ensure => $::nfs::pkg_ensure;
        }
      }

      if $::nfs::server {
        package { $::nfs::pkg_list_server:
          ensure => $::nfs::pkg_ensure;
        }
      }
    }

    default: {
      fail "Operating system ${::operatingsystem} is not supported yet."
    }
  }
}

