# Define tcpwrappers::allow
# ===========================
#
# Defined type which specifies and creates concat hosts.allow fragment
#
# @summary The tcpwrappers::allow class creates a concat fragment for constructing hosts.allow
#
# @example Creating a tcpwrappers rule in hosts.allow
#   tcpwrappers::allow { 'allow sshd':
#     client_list => 'ALL',
#     daemon_list => 'sshd',
#     $order      => '22_sshd_allow_all',
#     $comment    =>  'Allow all clients to reach sshd daemon',
#   }
#
# @param client_list A list of hosts affected by the rule. Operators can also be included in the string as appropriate. No validation is done to ensure that the are valid for tcpwrappers.
# @param daemon_list A list of daemons affected by the rule. Operators can also be included in the string as appropriate. No validation is done to ensure that they are valid for tcpwrappers.
# @param order Alphanumeric string that controls the ordering of concat fragments.
# @param allow_template Template to use for fragment. Allows one to specify a different locally developed template instead of the module provided one.
# @param comment A comment to be included in the concat fragment to allow for readibility of hosts.allow. The module template automatically places a "#" character in front of the comment.
# @param optional_actions An optional acction or list of actions to be carried out when the rule is hit. This defaults to allow; however, it can be overridden with an empty string to remove completely the options from the rule.
#
define tcpwrappers::allow (
  Variant[String,Array[String]]             $client_list,
  Variant[String,Array[String]]             $daemon_list,
  String                                    $order,
  Optional[String]                          $allow_template   = 'tcpwrappers/allow.erb',
  Optional[String]                          $comment          = undef,
  Optional[Variant[String,Array[String]]]   $optional_actions = 'ALLOW',
) {
  concat::fragment { "tcpwrappers_${name}":
    target  => "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}",
    order   => $order,
    content => template($allow_template),
  }
}
