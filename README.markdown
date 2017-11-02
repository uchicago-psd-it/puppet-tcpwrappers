# tcpwrappers

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-tcpwrappers.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-tcpwrappers)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with tcpwrappers](#setup)
    * [What tcpwrappers affects](#what-tcpwrappers-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tcpwrappers](#beginning-with-tcpwrappers)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module Description

If applicable, this section should have a brief description of the technology the module integrates with and what that integration enables. This section should answer the questions: "What does this module *do*?" and "Why would I use it?"

If your module has a range of functionality (installation, configuration, management, etc.) this is the time to mention it.

## Setup

### What tcpwrappers affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, etc.), mention it here.

### Beginning with tcpwrappers

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here.

## Reference

This module is setup for the use of Puppet Strings to generate class and parameter documentation. The [Puppet Strings doumentation](https://github.com/puppetlabs/puppet-strings/) provides more details on what Puppet Strings provides and other ways of generating documentaiton output.

As a quick start, if you are using the gem version of puppet:

```bash
gem install puppet-strings
puppet strings generate manifests/*.pp
```

The puppet strings command should be run from the root of the module directory. The resulting documentation will by default be placed in a docs/ directory within the module.

If you are setup with the development environment as described in the [CONTRIBUTING document](CONTRIBUTING.md) :

```bash
bundle exec rake strings:generate manifests/*.pp
```

from within the module directory will generate the documentation as well.

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-tcpwrappers/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).
