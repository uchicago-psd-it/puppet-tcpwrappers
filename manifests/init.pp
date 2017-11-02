# Class: tcpwrappers
# ===========================
#
# Main class that includes all other classes for the tcpwrappers module.
#
# @param package_ensure [String] Whether to install the tcpwrappers package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name [String] Specifies the name of the package to install. Default value: 'tcpwrappers'.
# @param service_enable [Boolean] Whether to enable the tcpwrappers service at boot. Default value: true.
# @param service_ensure [Enum['running', 'stopped']] Whether the tcpwrappers service should be running. Default value: 'running'.
# @param service_name [String] Specifies the name of the service to manage. Default value: 'tcpwrappers'.
#
class tcpwrappers (
  String                     $package_ensure = 'present',
  String                     $package_name   = 'tcpwrappers',
  Boolean                    $service_enable = true,
  Enum['running', 'stopped'] $service_ensure = 'running',
  String                     $service_name   = 'tcpwrappers',
  ) {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      contain tcpwrappers::install
      contain tcpwrappers::config
      contain tcpwrappers::service

      Class['tcpwrappers::install']
      -> Class['tcpwrappers::config']
      ~> Class['tcpwrappers::service']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
