# Class: tcpwrappers
# ===========================
#
# Main class that includes all other classes for the tcpwrappers module.
#
# @param package_ensure [String] Whether to install the tcpwrappers package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name [String] Specifies the name of the package to install. Default value: 'tcp_wrappers'.
#
class tcpwrappers (
  String                     $package_ensure = 'present',
  String                     $package_name   = 'tcp_wrappers',
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
