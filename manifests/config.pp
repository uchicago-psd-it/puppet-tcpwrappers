# @api private
#
# This class is called from tcpwrappers for service config.
#
class tcpwrappers::config {
  concat { "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}":
    ensure         => 'present',
    ensure_newline => true,
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    order          => 'alpha',
  }
  concat { "${tcpwrappers::config_dir}/${tcpwrappers::file_deny}":
    ensure         => 'present',
    ensure_newline => true,
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    order          => 'alpha',
  }
  if $tcpwrappers::allow_header {
    concat::fragment { 'tcpwrappers_allow_header':
      target => "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}",
      order  => '0_header',
      source => "puppet:///modules/${tcpwrappers::allow_header_source}",
    }
  }
  if $tcpwrappers::deny_header {
    concat::fragment { 'tcpwrappers_deny_header':
      target => "${tcpwrappers::config_dir}/${tcpwrappers::file_deny}",
      order  => '0_header',
      source => "puppet:///modules/${tcpwrappers::deny_header_source}",
    }
  }
}
