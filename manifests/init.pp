# == Class nfs
#
class nfs (
  $client            = $::nfs::params::client,
  $config_dir        = $::nfs::params::config_dir,
  $config_dir_mode   = $::nfs::params::config_dir_mode,
  $config_file       = $::nfs::params::config_file,
  $config_file_mode  = $::nfs::params::config_file_mode,
  $config_group      = $::nfs::params::config_group,
  $config_user       = $::nfs::params::config_user,
  $daemon_group      = $::nfs::params::daemon_group,
  $daemon_user       = $::nfs::params::daemon_user,
  $pkg_ensure        = $::nfs::params::pkg_ensure,
  $pkg_list          = $::nfs::params::pkg_list,
  $server            = $::nfs::params::server,
  $service_enable    = $::nfs::params::service_enable,
  $service_ensure    = $::nfs::params::service_ensure,
  $service_hasstatus = $::nfs::params::service_hasstatus,
  $service_name      = $::nfs::params::service_name,
  $service_rpc       = $::nfs::params::service_rpc,
  $service_idmap     = $::nfs::params::service_idmap,
  $statd_context     = $::nfs::params::statd_context,
  $statd_changes     = $::nfs::params::statd_changes,
  $mountd_context    = $::nfs::params::mountd_context,
  $mountd_changes    = $::nfs::params::mountd_changes,
  $lockd_tcpport     = $::nfs::params::lockd_tcpport,
  $lockd_udpport     = $::nfs::params::lockd_udpport,
  $callback_tcpport  = $::nfs::params::callback_tcpport,
  $sysctld_dir       = $::nfs::params::sysctld_dir,
) inherits nfs::params {
  include nfs::install
  include nfs::config
  include nfs::service

  Class['nfs::install'] ->
  Class['nfs::config'] ->
  Class['nfs::service']
}

