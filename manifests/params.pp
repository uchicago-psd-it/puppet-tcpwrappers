# == Class tcpwrappers::params
#
# This class is meant to be called from tcpwrappers.
# It sets variables according to platform.
#
class tcpwrappers::params {
  case $::osfamily {
    'RedHat': {
      $package_name = 'tcpwrappers'
      $service_name = 'tcpwrappers'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
