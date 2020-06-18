require 'spec_helper'

describe 'tcpwrappers::allows', :type => :class do
  context 'on all operating systems' do
    context 'with custom rules param' do
      let(:facts) do
        {
          :osfamily             => 'RedHat',
          :operatingsystem      => 'CentOS',
        }
      end

      let :params do
        {
          rules: {
            'spec_httpd' => {
              'client_list' => 'ALL',
              'daemon_list' => 'httpd',
              'order'       => '80_httpd_all',
              'comment'     => 'Allow all clients access to httpd',
            },
            'spec_telnet' => {
              'client_list' => 'ALL',
              'daemon_list' => 'ALL',
              'order'       => '22_telnet_all',
              'comment'     => 'Allow all clients access to telnet',
            },
            'spec_vsftpd' => {
              'client_list' => 'ALL',
              'daemon_list' => 'vsftpd',
              'order'       => '21_vsftpd_all',
              'comment'     => 'Allow all clients access to vsftpd',
            },
          },
        }
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('tcpwrappers') }
      it { is_expected.to contain_tcpwrappers__allow('spec_telnet') }
      it { is_expected.to contain_tcpwrappers__allow('spec_httpd') }
      it { is_expected.to contain_tcpwrappers__allow('spec_vsftpd') }

      it { is_expected.to contain_concat__fragment('tcpwrappers_spec_telnet').with(
              'target' => '/etc/hosts.allow',
              'order' => '22_telnet_all',
      ) }

      it { is_expected.to contain_concat__fragment('tcpwrappers_spec_httpd').with(
              'target' => '/etc/hosts.allow',
              'order' => '80_httpd_all',
      ) }
  
      it { is_expected.to contain_concat__fragment('tcpwrappers_spec_vsftpd').with(
              'target' => '/etc/hosts.allow',
              'order' => '21_vsftpd_all',
      ) }
    end
  end
end
