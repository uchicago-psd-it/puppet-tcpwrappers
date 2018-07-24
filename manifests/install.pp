# @api private
#
# This class is called from the main tcpwrappers class for install.
#
class tcpwrappers::install {
  include ::tcpwrappers
  package { $::tcpwrappers::package_name:
    ensure => $::tcpwrappers::package_ensure,
  }
}
