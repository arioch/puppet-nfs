# == Class nfs::config
#
class nfs::config {

  Exec {
    path => $::path,
  }

  File {
    ensure  => present,
    require => Class['::nfs::install'],
    notify  => Service[$::nfs::service_name],
    owner   => $::nfs::config_user,
    group   => $::nfs::config_group,
  }

  Augeas {
    require => Class['::nfs::install'],
    notify  => Service[$::nfs::service_name],
  }

  if $::nfs::server {
    concat { $::nfs::config_file:
      group  => $::nfs::config_group,
      mode   => $::nfs::config_mode,
      owner  => $::nfs::config_user,
      notify => Service[$::nfs::service_name],
    }

    concat::fragment { 'export_header':
      target  => $::nfs::config_file,
      content => "# Managed by Puppet\n\n",
      order   => 01,
    }


    if ("$::nfs::statd_context"){
      augeas {
        'nfs_statd_opts':
          context => $::nfs::statd_context,
          changes => $::nfs::statd_changes;
      }
    }

    if ("$::nfs::mountd_context") {
      augeas {
        'nfs_mountd_opts':
          context => $::nfs::mountd_context,
          changes => $::nfs::mountd_changes;
      }
    }

    if ("${::nfs::lockd_tcpport}"){
      exec {
        'nfs_lockd_tcpport':
          command => "sysctl -w fs.nfs.nlm_tcpport=${::nfs::lockd_tcpport}",
          unless  => "sysctl -n fs.nfs.nlm_tcpport | grep ^${::nfs::lockd_tcpport}$";
      }
    }

    if ("${::nfs::lockd_udpport}") {
      exec {
        'nfs_lockd_udpport':
          command => "sysctl -w fs.nfs.nlm_udpport=${::nfs::lockd_udpport}",
          unless  => "sysctl -n fs.nfs.nlm_udpport | grep ^${::nfs::lockd_udpport}$";
      }
    }

    if ("${::nfs::callback_tcpport}"){
      exec {
        'nfs_callback_tcpport':
          command => "sysctl -w fs.nfs.nfs_callback_tcpport=${::nfs::callback_tcpport}",
          unless  => "sysctl -n fs.nfs.nfs_callback_tcpport | grep ^${::nfs::callback_tcpport}$";
      }
    }

    if ( "${::nfs::sysctld_dir}" ) {
      file {
        "${::nfs::sysctld_dir}/nfs-kernel-server.conf":
          ensure  => present,
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('nfs/etc/sysctl.d/nfs-kernel-server.conf.erb'),
          notify  => undef;
      }
    }
    elsif ( "${::nfs::sysctld_file}" ){

      augeas {
        'nfs_lockd_tcpport':
          context => "/files${::nfs::sysctld_file}",
          changes => "set fs.nfs.nlm_tcpport ${::nfs::lockd_tcpport}",
      }

      augeas {
        'nfs_lockd_udpport':
          context => "/files${::nfs::sysctld_file}",
          changes => "set fs.nfs.nlm_udpport ${::nfs::lockd_udpport}",
      }

      augeas {
        'nfs_callbacl_tcpport':
          context => "/files${::nfs::sysctld_file}",
          changes => "set fs.nfs.nfs_callback_tcpport ${::nfs::callback_tcpport}",
      }

    }
  }
}

