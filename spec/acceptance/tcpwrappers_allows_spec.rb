require 'spec_helper_acceptance'

describe 'tcpwrappers::allow define' do
  context 'two basic test fragments' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
        class { 'tcpwrappers': }
        class { 'tcpwrappers::allows':
          rules => {
            spec_telnet => {
              client_list => 'ALL',
              daemon_list => 'telnet',
              order       => '22_telnet_all',
              comment     => 'Allow all clients access to telnet',
            },
            spec_vsftpd => {
              client_list => 'ALL',
              daemon_list => 'vsftpd',
              order       => '21_vsftpd_all',
              comment     => 'Allow all clients access to vsftpd',
            }
          }
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end
    describe file('/etc/hosts.allow') do
      it { should be_file }
      it { should contain 'Allow all clients access to telnet' }
      it { should contain 'telnet : ALL : ALLOW' }
      it { should contain 'Allow all clients access to vsftpd' }
      it { should contain 'vsftpd : ALL : ALLOW' }
    end
  end
end
