node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'tcpwrappers':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
