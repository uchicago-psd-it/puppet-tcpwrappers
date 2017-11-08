require 'spec_helper'

describe 'tcpwrappers::allows', :type => :class do
  context 'on all operating systems' do
    context 'params passed via hiera' do
      let(:facts) do
        {
          :osfamily             => 'RedHat',
          :operatingsystem      => 'CentOS',
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
