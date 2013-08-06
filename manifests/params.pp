# == Class nfs::params
#
class nfs::params {
  $client = true
  $server = false

  case $::osfamily {
    'RedHat': {
      $config_dir_mode    = '0755'
      $config_file        = '/etc/exports'
      $config_file_mode   = '0644'
      $config_group       = 'root'
      $config_user        = 'root'
      $pkg_ensure         = present
      $pkg_list_client    = 'nfs-utils'
      $pkg_list_server    = 'rpcbind'
      $service_enable     = true
      $service_ensure     = running
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_name       = 'nfs'
      $service_rpc        = 'rpcbind'
      $service_idmap      = 'rpcidmapd'
    }

    'Debian': {
      $config_dir_mode    = '0755'
      $config_file        = '/etc/exports'
      $config_file_mode   = '0644'
      $config_group       = 'root'
      $config_user        = 'root'
      $pkg_ensure         = present
      $pkg_list_client    = 'nfs-common'
      $pkg_list_server    = 'nfs-kernel-server'
      $service_enable     = true
      $service_ensure     = running
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_name       = 'nfs-kernel-server'
      $service_rpc        = 'portmap'
      $service_idmap      = 'tobeconfigured'
    }

    default: {
      fail "Operating system ${::operatingsystem} is not supported yet."
    }
  }
}

