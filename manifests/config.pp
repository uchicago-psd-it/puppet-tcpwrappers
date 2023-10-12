# @api private
#
# This class is called from tcpwrappers class to configure some basic pieces.
#
class tcpwrappers::config {
  assert_private()
  concat { "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}":
    ensure         => 'present',
    ensure_newline => true,
    owner          => $tcpwrappers::file_owner,
    group          => $tcpwrappers::file_group,
    mode           => '0644',
    order          => 'alpha',
  }
  unless $tcpwrappers::file_deny == $tcpwrappers::file_allow {
    concat { "${tcpwrappers::config_dir}/${tcpwrappers::file_deny}":
      ensure         => $tcpwrappers::file_deny_ensure,
      ensure_newline => true,
      owner          => $tcpwrappers::file_owner,
      group          => $tcpwrappers::file_group,
      mode           => '0644',
      order          => 'alpha',
    }
  }
  if $tcpwrappers::allow_header {
    concat::fragment { 'tcpwrappers_allow_header':
      target => "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}",
      order  => '0_header',
      source => "puppet:///modules/${tcpwrappers::allow_header_source}",
    }
  }
  if $tcpwrappers::allow_localhost_ipv4 {
    concat::fragment { 'tcpwrappers_allow_localhost_ipv4':
      target => "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}",
      order  => '0_localhost_ipv4',
      source => 'puppet:///modules/tcpwrappers/allow_localhost_ipv4',
    }
  }
  if $tcpwrappers::allow_localhost_ipv6 {
    concat::fragment { 'tcpwrappers_allow_localhost_ipv6':
      target => "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}",
      order  => '0_localhost_ipv6',
      source => 'puppet:///modules/tcpwrappers/allow_localhost_ipv6',
    }
  }
  if $tcpwrappers::allow_sshd_all {
    concat::fragment { 'tcpwrappers_allow_sshd_all':
      target => "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}",
      order  => '0_sshd_all',
      source => 'puppet:///modules/tcpwrappers/allow_sshd_all',
    }
  }
  if $tcpwrappers::deny_header {
    concat::fragment { 'tcpwrappers_deny_header':
      target => "${tcpwrappers::config_dir}/${tcpwrappers::file_deny}",
      order  => '0_header',
      source => "puppet:///modules/${tcpwrappers::deny_header_source}",
    }
  }
  if $tcpwrappers::default_deny {
    concat::fragment { 'tcpwrappers_default_deny':
      target  => "${tcpwrappers::config_dir}/${tcpwrappers::file_deny}",
      order   => 'ZZ_deny_all',
      content => 'ALL : ALL',
    }
  }
}
