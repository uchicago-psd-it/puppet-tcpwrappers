# Class: tcpwrappers
# ===========================
#
# Main class which will install tcpwrappers and begin management of hosts.allow and hosts.deny. The hosts.allow and hosts.deny files are set up by the class to emulate the files as they would be installed initially. Any tcpwrappers rules already existing in those files will be removed by the class when first applied to a system.
#
# @summary Main class which will install tcpwrappers and begin management of hosts.allow and hosts.deny. The hosts.allow and hosts.deny files are set up by the class to emulate the files as they would be installed initially. Any tcpwrappers rules already existing in those files will be removed by the class when first applied to a system.
#
# @example
#   include tcpwrappers
#
# @param allow_header Whether or not to include a header for hosts.allow  with order of 0_header.
# @param allow_header_source File to use as header for hosts.allow in the form of <modulename>/path/to/file which is then used by the source parameter of the fragment. As such, "files" should not appear in the path. This allows for replacing the module provided header with a locally generated one.
# @param allow_localhost_ipv4 Include the concat fragment to allow localhost ipv4 address (127.0.0.1) to access all daemons.
# @param allow_localhost_ipv6 Include the concat fragment to allow localhost ipv6 address (::1) to access all daemons.
# @param config_dir Specifies the directory for where the tcpwrappers configuration files are located.
# @param default_deny Whether or not to include 'ALL : ALL' in the hosts.deny file.
# @param deny_header Whether or not to include a header for hosts.deny with order of ZZ_deny_all.
# @param deny_header_source File to use as header for hosts.deny in the for of <modulename>/path/to/file which is then used by the source parameter of the fragment. As such, "files" should not appear in the path. This allows for replacing the module provided header with a locally generated one.
# @param file_allow Name for the hosts.allow file configuration file.
# @param file_deny Name for the hosts.deny configuration file.
# @param package_ensure Whether to install the tcpwrappers package, and what version. Suggested values: 'present', 'latest', or a specific version number. No validation of the String provided is done.
# @param package_name Specified the name of the package to install.
#
class tcpwrappers (
  Boolean         $allow_header         = true,
  String          $allow_header_source  = "tcpwrappers/allow_header_${facts}['os']['family']",
  Boolean         $allow_localhost_ipv4 = false,
  Boolean         $allow_localhost_ipv6 = false,
  Boolean         $allow_sshd_all       = false,
  String          $config_dir           = '/etc',
  Boolean         $default_deny         = false,
  Boolean         $deny_header          = true,
  String          $deny_header_source   = "tcpwrappers/deny_header_${facts}['os']['family']",
  String          $file_allow           = 'hosts.allow',
  String          $file_deny            = 'hosts.deny',
  Boolean         $file_deny_ensure     = true,
  String          $package_ensure       = 'present',
  String          $package_name         = 'tcp_wrappers',
  ) {
  case $facts['os']['family'] {
    'RedHat': {
      contain tcpwrappers::install
      contain tcpwrappers::config

      Class['tcpwrappers::install']
      -> Class['tcpwrappers::config']
    }
    'FreeBSD': {
      contain tcpwrappers::config
    }
    default: {
      fail("${facts}['os']['name'] not supported")
    }
  }
}
