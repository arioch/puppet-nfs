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

    augeas {
      'nfs_statd_opts':
        context => $::nfs::statd_context,
        changes => $::nfs::statd_changes;

      'nfs_mountd_opts':
        context => $::nfs::mountd_context,
        changes => $::nfs::mountd_changes;
    }

    exec {
      'nfs_lockd_tcpport':
        command => "sysctl -w fs.nfs.nlm_tcpport=${::nfs::lockd_tcpport}",
        unless  => "sysctl -n fs.nfs.nlm_tcpport | grep ^${::nfs::lockd_tcpport}$";

      'nfs_lockd_udpport':
        command => "sysctl -w fs.nfs.nlm_udpport=${::nfs::lockd_udpport}",
        unless  => "sysctl -n fs.nfs.nlm_udpport | grep ^${::nfs::lockd_udpport}$";

      'nfs_callback_tcpport':
        command => "sysctl -w fs.nfs.nfs_callback_tcpport=${::nfs::callback_tcpport}",
        unless  => "sysctl -n fs.nfs.nfs_callback_tcpport | grep ^${::nfs::callback_tcpport}$";
    }

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
}

