require 'spec_helper'

describe 'tcpwrappers::allow', :type => :define do
  let :pre_condition do
    'class { "tcpwrappers": }'
  end
  let :title do
    'test_frag'
  end

  describe "tests that do not depend on operating system differences" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '7',
        :operatingsystem        => 'RedHat',
      }
    end

    describe "basic test" do
      let :params do
        {
          :client_list      => 'ALL',
          :daemon_list      => 'ALL',
          :order            => '66_test_frag',
          :comment          => 'Allow all traffic to all services',
          :optional_actions => 'ALLOW',
        }
      end
      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '66_test_frag',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow all traffic to all services/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/ALL : ALL : ALLOW/) }
    end

    context "tcpwrappers::allow with params for allowing all snmpd traffic from two clients" do
      let :params do
        {
          :client_list      => [ '.example.com', '192.168.' ],
          :daemon_list      => 'snmpd',
          :optional_actions => 'ALLOW',
          :order            => '161_snmpd_limited',
          :comment          => 'Allow snmpd traffic from example.com or 192.168.'
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '161_snmpd_limited',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow snmpd traffic from example.com or 192.168./) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/snmpd : .example.com : ALLOW/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/snmpd : 192.168. : ALLOW/) }
    end

    context "tcpwrappers::allow with params for allowing all traffic to two daemons" do
      let :params do
        {
          :client_list      => 'ALL',
          :daemon_list      => [ 'sshd', 'httpd', ],
          :optional_actions => 'ALLOW',
          :order            => '66_sshd_httpd_all',
          :comment          => 'Allow all traffic to sshd and httpd'
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '66_sshd_httpd_all',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow all traffic to sshd and httpd/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : ALL : ALLOW/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/httpd : ALL : ALLOW/) }
    end

    context "tcpwrappers::allow with params for allowing traffic to two daemons from two clients" do
      let :params do
        {
          :client_list      => [ '.example.com', '192.168.' ],
          :daemon_list      => [ 'sshd', 'httpd', ],
          :optional_actions => 'ALLOW',
          :order            => '66_sshd_httpd_limited',
          :comment          => 'Allow traffic to sshd and httpd from example.com and 192.168.'
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '66_sshd_httpd_limited',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow traffic to sshd and httpd from example.com and 192.168./) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : .example.com : ALLOW/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : 192.168. : ALLOW/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/httpd : .example.com : ALLOW/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/httpd : 192.168. : ALLOW/) }
    end

    context "tcpwrappers::allow with params for logging and denying access to sshd from example.com clients " do
      let :params do
        {
          :client_list      => '.example.com',
          :daemon_list      => 'sshd',
          :optional_actions => [ 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log', 'DENY', ],
          :order            => '66_sshd_deny_example',
          :comment          => 'Allow fragment with options to log and deny access to sshd from .example.com clients'
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '66_sshd_deny_example',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow fragment with options to log and deny access to sshd from .example.com clients/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : .example.com \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/: spawn \/bin\/echo \`\/bin\/date\` access denied\>\>\/var\/log\/sshd.log \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/: DENY/) }
    end

    context "tcpwrappers::allow with params for logging and denying access to sshd from example.com and 192.186. clients " do
      let :params do
        {
          :client_list      => [ '.example.com', '192.168.', ],
          :daemon_list      => 'sshd',
          :optional_actions => [ 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log', 'DENY', ],
          :order            => '66_sshd_deny_example_192',
          :comment          => 'Allow fragment with options to log and deny access to sshd from .example.com and 192.168. clients'
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '66_sshd_deny_example_192',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow fragment with options to log and deny access to sshd from .example.com and 192.168. clients/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : .example.com \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : 192.168. \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/: spawn \/bin\/echo \`\/bin\/date\` access denied\>\>\/var\/log\/sshd.log \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/: DENY/) }
    end

    context "tcpwrappers::allow with params for logging and denying access to sshd and httpd from example.com and 192.186. clients " do
      let :params do
        {
          :client_list      => [ '.example.com', '192.168.', ],
          :daemon_list      => [ 'sshd', 'httpd', ],
          :optional_actions => [ 'spawn /bin/echo `/bin/date` access denied>>/var/log/access_denied.log', 'DENY', ],
          :order            => '66_sshd_httpd_deny_example_192',
          :comment          => 'Allow fragment with options to log and deny access to sshd and httpd from .example.com and 192.168. clients'
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '66_sshd_httpd_deny_example_192',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow fragment with options to log and deny access to sshd and httpd from .example.com and 192.168. clients/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : .example.com \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/sshd : 192.168. \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/httpd : .example.com \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/httpd : 192.168. \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/: spawn \/bin\/echo \`\/bin\/date\` access denied\>\>\/var\/log\/access_denied.log \\/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/: DENY/) }
    end

    context "tcpwrappers::allow with params to allow all hosts from example.com except a specific one" do
      let :params do
        {
          :client_list      => '.example.com EXCEPT badactor.example.com',
          :daemon_list      => 'ALL',
          :optional_actions => 'ALLOW',
          :order            => '20_allow_example_except_badactor',
          :comment          => 'Allow all traffic from .example.com except from badactor.example.com',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '20_allow_example_except_badactor',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow all traffic from .example.com except from badactor.example.com/) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/ALL : .example.com EXCEPT badactor.example.com : ALLOW/) }
    end

    context "tcpwrappers::allow with params to allow access to all service except vsftd from 192.168." do
      let :params do
        {
          :client_list      => '192.168.',
          :daemon_list      => 'ALL EXCEPT vsftpd',
          :optional_actions => 'ALLOW',
          :order            => '20_allow_except_vsftpd_192',
          :commend          => 'Allow all service traffic except vsftpd from 192.168.',
        }

      it { is_expected.to compile }
      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with(
        'target' => '/etc/hosts.allow',
        'order'  => '20_allow_except_vsftpd_192',
      ) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/Allow all service traffic except vsftpd from 192.168./) }
      it { is_expected.to contain_concat__fragment('tcpwrappers_test_frag').with_content(/ALL EXCEPT vsftpd : 192.168./) }
      end
    end
  end
end
