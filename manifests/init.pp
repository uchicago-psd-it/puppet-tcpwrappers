# Class: tcpwrappers
# ===========================
#
# Main class that includes all other classes for the tcpwrappers module.
#
# @param package_ensure [String] Whether to install the tcpwrappers package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name [String] Specifies the name of the package to install. Default value: 'tcp_wrappers'.
#
class tcpwrappers (
  Boolean         $allow_header = true,
  String          $allow_header_source = "tcpwrappers/allow_header_${::operatingsystem}",
  Boolean         $allow_localhost = true,
  String          $config_dir = '/etc',
  Boolean         $default_deny = true,
  Boolean         $deny_header = true,
  String          $deny_header_source = "tcpwrappers/deny_header_${::operatingsystem}",
  String          $file_allow = 'hosts.allow',
  String          $file_deny  = 'hosts.deny',
  String          $package_ensure = 'present',
  String          $package_name   = 'tcp_wrappers',
  ) {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      contain tcpwrappers::install
      contain tcpwrappers::config

      Class['tcpwrappers::install']
      -> Class['tcpwrappers::config']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
