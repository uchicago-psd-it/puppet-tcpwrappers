# @api private
#
# This class is meant to be called from tcpwrappers to manage the tcpwrappers service.
#
class tcpwrappers::service {

  service { $::tcpwrappers::service_name:
    ensure     => $::tcpwrappers::service_ensure,
    enable     => $::tcpwrappers::service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
