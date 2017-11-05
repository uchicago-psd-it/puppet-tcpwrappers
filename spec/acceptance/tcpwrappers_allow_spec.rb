require 'spec_helper_acceptance'

describe 'tcpwrappers::allow define' do
  context 'basic test fragment' do
    let(:pp) { "class { 'tcpwrappers': }" }

    it 'should work idempotently with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_failures => true)
    end

    describe package('tcp_wrappers') do
      it { should be_installed }
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain 'Puppet managed file. Local changes will be overwritten.' }
      it { should contain 'allow or deny connections to network services that' }
      it { should_not contain 'ALLOW' }
      it { should_not contain 'DENY' }
    end

    describe file('/etc/hosts.deny') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain 'Puppet managed file. Local changes will be overwritten.' }
      it { should contain 'deny connections to network services that either use' }
      it { should_not contain 'DENY' }
      it { should_not contain ': ALLOW' }
    end
  end

  context 'allow traffic to snmpd from two clients' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => [ '.example.com', '192.168.' ],
          daemon_list      => 'snmpd',
          order            => '161_snmpd_limited',
          optional_actions => 'ALLOW',
          comment          => 'Allow snmpd traffic from example.com or 192.168.',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow snmpd traffic from example.com or 192.168.' }
      it { should contain 'snmpd : .example.com : ALLOW' }
      it { should contain 'snmpd : 192.168. : ALLOW' }
    end
  end

  context 'allow traffic to snmpd from two clients without optional_actions' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => [ '.example.com', '192.168.' ],
          daemon_list      => 'snmpd',
          order            => '161_snmpd_limited',
          optional_actions => '',
          comment          => 'Allow snmpd traffic from example.com or 192.168.',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow snmpd traffic from example.com or 192.168.' }
      it { should contain 'snmpd : .example.com' }
      it { should contain 'snmpd : 192.168.' }
      it { should_not contain ': ALLOW' }
    end
  end

  context 'allow all clients to two daemons' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => 'ALL',
          daemon_list      => [ 'sshd', 'httpd', ],
          order            => '66_sshd_httpd_all',
          optional_actions => 'ALLOW',
          comment          => 'Allow all traffic to sshd and httpd',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow all traffic to sshd and httpd' }
      it { should contain 'sshd : ALL : ALLOW' }
      it { should contain 'httpd : ALL : ALLOW' }
    end
  end

  context 'allow all clients to two daemons without optional_actions' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => 'ALL',
          daemon_list      => [ 'sshd', 'httpd', ],
          order            => '66_sshd_httpd_all',
          optional_actions => '',
          comment          => 'Allow all traffic to sshd and httpd',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow all traffic to sshd and httpd' }
      it { should contain 'sshd : ALL' }
      it { should contain 'httpd : ALL' }
      it { should_not contain ': ALLOW' }
    end
  end

  context 'allow traffic to two daemons from two clients' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => [ '.example.com', '192.168.' ],
          daemon_list      => [ 'sshd', 'httpd', ],
          order            => '66_sshd_httpd_limited',
          optional_actions => 'ALLOW',
          comment          => 'Allow traffic to sshd and httpd from example.com and 192.168.',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow traffic to sshd and httpd from example.com and 192.168.' }
      it { should contain 'sshd : .example.com : ALLOW' }
      it { should contain 'sshd : 192.168. : ALLOW' }
      it { should contain 'httpd : .example.com : ALLOW' }
      it { should contain 'httpd : 192.168. : ALLOW' }
    end
  end

  context 'allow traffic to two daemons from two clients without optional_actions' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => [ '.example.com', '192.168.' ],
          daemon_list      => [ 'sshd', 'httpd', ],
          order            => '66_sshd_httpd_limited',
          optional_actions => '',
          comment          => 'Allow traffic to sshd and httpd from example.com and 192.168.',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow traffic to sshd and httpd from example.com and 192.168.' }
      it { should contain 'sshd : .example.com' }
      it { should contain 'sshd : 192.168.' }
      it { should contain 'httpd : .example.com' }
      it { should contain 'httpd : 192.168.' }
      it { should_not contain ': ALLOW' }
    end
  end

  context 'log and deny access to sshd from example.com clients' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => '.example.com',
          daemon_list      => 'sshd',
          order            => '66_sshd_deny_example',
          optional_actions => [ 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log', 'DENY', ],
          comment          => 'Allow fragment with options to log and deny access to sshd from .example.com clients',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow fragment with options to log and deny access to sshd from .example.com clients' }
      it { should contain 'sshd : .example.com \\' }
      it { should contain 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \\' }
      it { should contain ': DENY' }
      it { should_not contain ': ALLOW' }
    end
  end

  context 'log and deny access to sshd from example.com and 192.168. clients' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => [ '.example.com', '192.168.', ],
          daemon_list      => 'sshd',
          order            => '66_sshd_deny_example_192',
          optional_actions => [ 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log', 'DENY', ],
          comment          => 'Allow fragment with options to log and deny access to sshd from .example.com and 192.168. clients',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow fragment with options to log and deny access to sshd from .example.com and 192.168. clients' }
      it { should contain 'sshd : .example.com \\' }
      it { should contain 'sshd : 192.168. \\' }
      it { should contain 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \\' }
      it { should contain ': DENY' }
      it { should_not contain ': ALLOW' }
    end
  end

  context 'log and deny access to sshd and httpd from example.com and 192.168. clients' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => [ '.example.com', '192.168.', ],
          daemon_list      => [ 'sshd', 'httpd', ],
          order            => '66_sshd_httpd_deny_example_192',
          optional_actions => [ 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log', 'DENY', ],
          comment          => 'Allow fragment with options to log and deny access to sshd and httpd from .example.com and 192.168. clients',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow fragment with options to log and deny access to sshd and httpd from .example.com and 192.168. clients' }
      it { should contain 'sshd : .example.com \\' }
      it { should contain 'sshd : 192.168. \\' }
      it { should contain 'httpd : .example.com \\' }
      it { should contain 'httpd : 192.168. \\' }
      it { should contain 'spawn /bin/echo `/bin/date` access denied>>/var/log/sshd.log \\' }
      it { should contain ': DENY' }
      it { should_not contain ': ALLOW' }
    end
  end

 context 'allow all traffic from example.com except a specific one' do
   it 'should work idempotently with no errors' do
     pp = <<-EOS
       class { 'tcpwrappers': }
       tcpwrappers::allow { 'tcpwrappers_test_frag':
         client_list      => '.example.com EXCEPT badactor.example.com',
         daemon_list      => 'ALL',
         order            => '20_allow_example_except_badactor',
         optional_actions => 'ALLOW',
         comment          => 'Allow all traffic from .example.com except from badactor.example.com',
       }
     EOS

     apply_manifest(pp, :catch_failures => true)
     apply_manifest(pp, :catch_changes  => true)
   end

   describe file('/etc/hosts.allow') do
     it { should be_file }
     it { should contain 'Allow all traffic from .example.com except from badactor.example.com' }
     it { should contain 'ALL : .example.com EXCEPT badactor.example.com : ALLOW' }
   end
 end

  context 'allow all traffic from example.com except a specific one without specific optional action' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => '.example.com EXCEPT badactor.example.com',
          daemon_list      => 'ALL',
          order            => '20_allow_example_except_badactor',
          optional_actions => '',
          comment          => 'Allow all traffic from .example.com except from badactor.example.com',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow all traffic from .example.com except from badactor.example.com' }
      it { should contain 'ALL : .example.com EXCEPT badactor.example.com' }
      it { should_not contain ': ALLOW' }
    end
  end

  context 'allow access to all services except vsftd from 192.168.' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => '192.168.',
          daemon_list      => 'ALL EXCEPT vsftpd',
          order            => '20_allow_except_vsftpd_192',
          optional_actions => 'ALLOW',
          comment          => 'Allow all service traffic except vsftpd from 192.168.',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow all service traffic except vsftpd from 192.168.' }
      it { should contain 'ALL EXCEPT vsftpd : 192.168. : ALLOW' }
    end
  end

  context 'allow access to all services except vsftd from 192.168. without specific optional action' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        tcpwrappers::allow { 'tcpwrappers_test_frag':
          client_list      => '192.168.',
          daemon_list      => 'ALL EXCEPT vsftpd',
          order            => '20_allow_except_vsftpd_192',
          optional_actions => '',
          comment          => 'Allow all service traffic except vsftpd from 192.168.',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow all service traffic except vsftpd from 192.168.' }
      it { should contain 'ALL EXCEPT vsftpd : 192.168.' }
      it { should_not contain ': ALLOW' }
    end
  end
end
