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
