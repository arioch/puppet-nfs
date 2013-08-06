# == Class nfs::install
#
class nfs::install {
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

