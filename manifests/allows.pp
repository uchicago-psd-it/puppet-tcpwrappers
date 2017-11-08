# Class tcpwrappers::allows
# ===========================
#
# Class which when included uses either the rules parameter or merged data from lookup to create tcpwrappers concat fragments.
#
# @summary Class which when included uses either the rules parameter or merged data from lookup to create tcpwrappers concat fragments.
#
# @example hiera file providing data for the merge lookup
#   tcpwrappers::allows::rules:
#     sshd_all
#       client_list: ALL
#       daemon_list: sshd
#       order: 22_sshd_all
#       comment: 'Allow all clients access to sshd'
#     vsftpd_all:
#       client_list: ALL
#       daemon_list: vsftpd
#       order: 21_vsftpd_all
#       comment: 'Allow all clients access to vsftpd'
#
# @param rules Hash of rules for which each will result in creation of a resource using the define type tcpwrappers::allow.
#
class tcpwrappers::allows (
  Hash $rules = {},
) {
  include tcpwrappers

  $rules.each |String $key, Hash $attrs| {
    tcpwrappers::allow { $key:
      * =>  $attrs,
    }
  }
}
