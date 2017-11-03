require 'spec_helper'

describe 'tcpwrappers' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "tcpwrappers class without any parameters changed from defaults" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('tcpwrappers::install') }
          it { is_expected.to contain_class('tcpwrappers::config') }
          it { is_expected.to contain_class('tcpwrappers::install').that_comes_before('Class[tcpwrappers::config]') }


          it { is_expected.to contain_package('tcp_wrappers').with_ensure('present') }

          it { is_expected.to contain_concat('/etc/hosts.allow').with(
            'ensure'         => 'present',
            'ensure_newline' => 'true',
            'owner'          => 'root',
            'group'          => 'root',
            'mode'           => '0644',
            'order'          => 'alpha',
          ) }

          it { is_expected.to contain_concat('/etc/hosts.deny').with(
            'ensure'         => 'present',
            'ensure_newline' => 'true',
            'owner'          => 'root',
            'group'          => 'root',
            'mode'           => '0644',
            'order'          => 'alpha',
          ) }

          it { is_expected.to contain_concat__fragment('tcpwrappers_allow_header').with(
            'target' => '/etc/hosts.allow',
            'order' => '0_header',
          ) }

          if facts[:os]['name'] == "CentOS"
            it { is_expected.to contain_concat__fragment('tcpwrappers_allow_header').with_source('puppet:///modules/tcpwrappers/allow_header_CentOS') }
          end

          if facts[:os]['name'] == "RedHat"
            it { is_expected.to contain_concat__fragment('tcpwrappers_allow_header').with_source('puppet:///modules/tcpwrappers/allow_header_RedHat') }
          end

          it { is_expected.to contain_concat__fragment('tcpwrappers_deny_header').with(
            'target' => '/etc/hosts.deny',
            'order' => '0_header',
          ) }

          if facts[:os]['name'] == "CentOS"
            it { is_expected.to contain_concat__fragment('tcpwrappers_deny_header').with_source('puppet:///modules/tcpwrappers/deny_header_CentOS') }
          end

          if facts[:os]['name'] == "RedHat"
            it { is_expected.to contain_concat__fragment('tcpwrappers_deny_header').with_source('puppet:///modules/tcpwrappers/deny_header_RedHat') }
          end
        end

        context "tcpwrappers class with allow_header set to false" do
          let(:params){
            {
              :allow_header => false,
            }
          }

          it { is_expected.to_not contain_concat__fragment('tcpwrappers_allow_header') }
        end

        context "tcpwrappers class with config_dir set to /foo" do
          let(:params){
            {
              :config_dir => '/foo',
            }
          }

          it { is_expected.to contain_concat('/foo/hosts.allow') }
          it { is_expected.to contain_concat__fragment('tcpwrappers_allow_header').with_target('/foo/hosts.allow') }
          it { is_expected.to contain_concat('/foo/hosts.deny') }
          it { is_expected.to contain_concat__fragment('tcpwrappers_deny_header').with_target('/foo/hosts.deny') }
        end

        context "tcpwrappers class with deny_header set to false" do
          let(:params){
            {
              :deny_header => false,
            }
          }

          it { is_expected.to_not contain_concat__fragment('tcpwrappers_deny_header') }
        end

        context "tcpwrappers class with file_allow parameter set to foo.allow" do
          let(:params){
            {
              :file_allow => 'foo.allow',
            }
          }

          it { is_expected.to contain_concat('/etc/foo.allow') }
          it { is_expected.to contain_concat__fragment('tcpwrappers_allow_header').with_target('/etc/foo.allow') }
        end

        context "tcpwrappers class with file_deny parameter set to foo.deny" do
          let(:params){
            {
              :file_deny => 'foo.deny',
            }
          }

          it { is_expected.to contain_concat('/etc/foo.deny') }
          it { is_expected.to contain_concat__fragment('tcpwrappers_deny_header').with_target('/etc/foo.deny') }
        end
        context "tcpwrappers class with package_ensure set to latest" do
          let(:params){
            {
              :package_ensure => 'latest',
            }
          }

          it { is_expected.to contain_package('tcp_wrappers').with_ensure('latest') }
        end
        context "tcpwrappers class with package_name set to tcp_foo" do
          let(:params){
            {
              :package_name => 'tcp_foo',
            }
          }

          it { is_expected.to_not contain_package('tcp_wrappers') }
          it { is_expected.to contain_package('tcp_foo') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'tcpwrappers class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('tcpwrappers') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
