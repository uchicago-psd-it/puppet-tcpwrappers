require 'spec_helper_acceptance'

describe 'tcpwrappers class' do
  context 'with default parameters' do
    let(:pp) { "class { 'tcpwrappers': }" }

    it 'should work idempotently with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
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
    end
  end

  context 'with allow_header set to false' do
    let(:pp) { "class { 'tcpwrappers': allow_header => false, allow_localhost_ipv4 => true, }" }
    it 'should work idempotently with no errors' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should_not contain 'Puppet managed file. Local changes will be overwritten.' }
      it { should_not contain 'allow or deny connections to network services that' }
    end

  end

  context 'with allow_localhost_ipv4 set to true' do
    let(:pp) { "class { 'tcpwrappers': allow_localhost_ipv4 => true, }" }
    it 'should work idempotently with no errors' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should contain 'ALL : 127.0.0.1 : ALLOW' }
    end
  end

  context 'with allow_localhost_ipv6 set to true' do
    let(:pp) { "class { 'tcpwrappers': allow_localhost_ipv6 => true, }" }
    it 'should work idempotently with no errors' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/hosts.allow') do
      it { should contain 'ALL : [::1] : ALLOW' }
    end
  end

#  context 'with default_deny set to true' do
#    let(:pp) { "class { 'tcpwrappers': default_deny => true, }" }
#
#    it 'should work idempotently with no errors' do
#      apply_manifest(pp, :catch_failures => true)
#      apply_manifest(pp, :catch_changes  => true)
#    end
#
#    describe file('/etc/hosts.deny') do
#      it { should contain 'ALL : ALL' }
#    end
#  end
end
