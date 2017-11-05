# Define tcpwrappers::allow
# ===========================
#
# Define type which specifies hosts.allow fragment
#
#
define tcpwrappers::allow (
  Variant[String,Array[String]]             $client_list,
  Variant[String,Array[String]]             $daemon_list,
  String                                    $order,
  Optional[String]                          $allow_template = 'tcpwrappers/allow.erb',
  Optional[String]                          $comment = undef,
  Optional[Variant[String,Array[String]]]   $optional_actions = 'ALLOW',
) {
  concat::fragment { "tcpwrappers_${name}":
    target  => "${tcpwrappers::config_dir}/${tcpwrappers::file_allow}",
    order   => $order,
    content => template("${allow_template}"),
  }
}
