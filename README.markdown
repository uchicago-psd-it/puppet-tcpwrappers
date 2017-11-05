# tcpwrappers

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-tcpwrappers.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-tcpwrappers)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with tcpwrappers](#setup)
    * [What tcpwrappers affects](#what-tcpwrappers-affects)
    * [Beginning with tcpwrappers](#beginning-with-tcpwrappers)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module Description

The tcpwrappers module allows for the installation and configuration of access rules.

Upon inclusion of the class, it will install the tcpwrappers package and set the hosts.allow and hosts.deny files to what was originally included on the operating system with the addition of a warning comment at the top of the file that the hosts.allow and hosts.deny file are now managed via puppet.

Warning: If this class is applied to a system with hosts.allow and/or hosts.deny rules already present, those rules will be removed.

## Setup

### What tcpwrappers affects

* Packages: RedHat osfamily: tcpwrappers.
* File: RedHat osfamily: /etc/hosts.allow
* File: RedHat osfamily: /etc/hosts.deny

### Beginning with tcpwrappers

`include tcpwrappers` should be all that is needed to install and configure tcpwrappers to the system defaults.

## Usage

All parameters to the main class can be passed via puppet code or hiera. A module data folder for hiera 5 is included. Currently, rule generation via the tcpwrappers::allow class can only be done via puppet code. Adding the ability to drive rules via hiera/create_resources is a high priority item on the to dos.

Some examples are presented below showing the purpose of some of the indidual parameters to the main class. Those generating rules in hosts.allow show how to create those rules similar to those listed in the RedHat/CentOS tcpwrappers documentation.

### Install tcpwrappers onto a system and configure default hosts.allow/hosts.deny files

```puppet
include tcpwrappers
```

### Install tcpwrappers and ensure that the version is always the most recent package available

```puppet
class { 'tcpwrappers':
  package_ensure => 'latest',
}
```

or via hiera:

```yaml
tcpwrappers::package_ensure: 'latest'
```

### Install tcpwrappers and include 'ALL : ALL' in hosts.deny to block all specifically allowed access

```puppet
class { 'tcpwrappers':
  default_deny => true,
}
```

### Install tcpwrappers and allow traffic to all services from the localhost IPv4/6 address:

```puppet
class { 'tcpwrappers':
    allow_localhost_ipv4 => true,
    allow_localhost_ipv6 => true,
}
```

### Install tcpwrappers and allow traffic to sshd from all clients

```puppet
class{ 'tcpwrappers':
  allow_sshd_all => true,
}
```

### Access rule to allow all clients access to all daemons

```puppet
tcpwrappers::allow { 'all_all_allow':
  client_list => 'ALL',
  daemon_list => 'ALL',
  order       => '10_all_all_allow',
  comment     => 'Allow all clients access to all daemons',
}
```

### Allow all clients access to the sshd and httpd daemons

```puppet
tcpwrappers::allow { 'all_sshd_httpd':
  client_list => 'ALL',
  daemon_list => [ 'sshd', 'httpd', ],
  order       => '66_all_sshd_httpd',
  comment     => 'Allow all clients access to sshd and httpd',
}
```

### Allow access to snmpd from two specified client definitions

```puppet
tcpwrappers::allow { 'example_snmpd':
  client_list => [ '.example.com', '192.168.', ],
  daemon_list => 'snmpd',
  order       => '161_example_snmpd',
  comment     => 'Allow access to snmpd from the example.com domain and IP addresses',
}
```

### Allow traffic to sshd and httpd from the example.com domain

```puppet
tcpwrappers::allow { 'example_sshd_httpd':
  client_list => [ '.example.com', '192.168.', ],
  daemon_list => [ 'sshd', 'httpd', ],
  order       => '22_example_sshd_httpd',
  comment     => 'Allow traffic to sshd and httpd from the example.com domain and IP addresses',
}
```

### Rule for logging and denying access to sshd from example.com

```puppet
tcpwrappers::allow { 'example_sshd_deny':
  client_list      => '.example.com',
  daemon_list      => 'sshd',
  order            => '22_example_sshd_deny',
  comment          => 'Log and deny access to sshd from example.com',
  optional_actions => [ 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log', 'DENY', ],
}
```

### Allow access to sshd from example.com except for badactor.example.com

```puppet
tcpwrappers::allow { 'example_sshd_no_badactor':
  client_list => '.example.com EXCEPT badactor.example.com',
  daemon_list => 'sshd',
  order       => '22_example_sshd_no_badactor',
  comment     => 'Allow traffic to sshd from example.com domain except from badactor.example.com',
}
```

### Allow access to all daemons except vsftd from 192.168. without an action specified

```puppet
tcpwrappers::allow { 'all_except_vsfptd_192_168':
  client_list      => '192.168.',
  daemon_list      => 'ALL EXCEPT vsftpd',
  optional_actions => '',
  order            => '10_except_vsftpd_192_186',
  comment          => 'Allow access to all daemons except vsftpd from 192.168.',
}
```

## Reference

Generated puppet strings documentation with examples is available from [https://millerjl1701.github.io/millerjl1701-tcpwrappers/](https://millerjl1701.github.io/millerjl1701-tcpwrappers/)

The puppet strings documentation is also included in the github repository in the /docs folder.

### Public Classes

* tcpwrappers: Main class which installs and configured tcpwrappers. Parameters can be passed via class declaration or hiera.
* tcpwrappers::allow: Class for creating a hosts.allow rule.

### Private Classes

* tcpwrappers::config: Class which performs some initial configuration of tcpwrappers. All behavior is driven using parameters to the main class.

### Parameters

The tcpwrappers::init class has the following parameters:

```puppet
Boolean         $allow_header         = true,
String          $allow_header_source  = "tcpwrappers/allow_header_${::operatingsystem}",
Boolean         $allow_localhost_ipv4 = false,
Boolean         $allow_localhost_ipv6 = false,
Boolean         $allow_sshd_all       = false,
String          $config_dir           = '/etc',
Boolean         $default_deny         = false,
Boolean         $deny_header          = true,
String          $deny_header_source   = "tcpwrappers/deny_header_${::operatingsystem}",
String          $file_allow           = 'hosts.allow',
String          $file_deny            = 'hosts.deny',
String          $package_ensure       = 'present',
String          $package_name         = 'tcp_wrappers',
```

The tcpwrappers::allow class has the following parameters:

```puppet
Variant[String,Array[String]]             $client_list,
Variant[String,Array[String]]             $daemon_list,
String                                    $order,
Optional[String]                          $allow_template   = 'tcpwrappers/allow.erb',
Optional[String]                          $comment          = undef,
Optional[Variant[String,Array[String]]]   $optional_actions = 'ALLOW',
```

## Limitations

This file was setup using CentOS 6 and 7 installation and documentation for rules. In time, other operating systems will be added as they have been tested. Pull requests with tests are welcome!

This module was written to simplify the creation of hosts.allow and hosts.deny rules on a system. However, no validation of the rules is done. This is left as an exercise for the reader.

Warning: If this module is applied to a system that already has rules in hosts.allow and hosts.deny specified, they will be removed by the module.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-tcpwrappers/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).
