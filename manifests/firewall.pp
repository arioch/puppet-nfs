# = Class nfs::firewall
#
class nfs::firewall {
  $firewall_exists = inline_template("<%= File.exists?('/var/lib/puppet/lib/puppet/provider/firewall/iptables.rb') %>")
  if $::nfs::server and $::nfs::service_ensure==running and $firewall_exists {
    firewall { "049 allow incoming nfs tcp-connections":
      proto   => tcp,
      dport   => $::nfs::firewall_port,
      action  => accept,
    }
    firewall { "049 allow incoming nfs udp-connections":
      proto   => udp,
      dport   => $::nfs::firewall_port,
      action  => accept,
    }
  }
}
