# @api private
#
# This class is called from the main tcpwrappers class for install.
#
class tcpwrappers::install {
  package { $::tcpwrappers::package_name:
    ensure => $::tcpwrappers::package_ensure,
  }
}
