# @api private
#
# This class is called from the main tcpwrappers class for install.
#
class tcpwrappers::install {
  assert_private()
  package { $::tcpwrappers::package_name:
    ensure => $::tcpwrappers::package_ensure,
  }
}
