require 'spec_helper'

describe 'accounts', :type => :class do
  let(:facts) { {
    :osfamily => 'Debian',
    :puppetversion => Puppet.version,
  } }
  let(:params){{
    :manage_users  => true,
    :manage_groups => true,
  }}

  it { should compile.with_all_deps }
  it { should contain_class('accounts::users') }
  it { should contain_class('accounts::groups') }

  context 'allow passing users and groups directly to init class' do
    let(:params){{
      :users => { 'john' => { 'comment' => 'John Doe', 'gid' => 2001 }},
      :groups => { 'developers' => { 'gid' => 2001 }}
    }}

    it { should contain_user('john').with(
      'comment' => 'John Doe',
      'gid' => 2001
    )}

    it { should contain_group('developers').with(
      'gid'    => 2001,
      'ensure' => 'present'
    )}
  end

  context 'no group management' do
    let(:params){{
      :users => { 'john' => { 'comment' => 'John Doe', 'gid' => 'john' }},
      :groups => { 'developers' => { 'gid' => 2001 }},
      :manage_groups => false,
    }}

    it { should contain_user('john').with(
      'comment' => 'John Doe',
      'gid' => 'john'
    )}

    it { should_not contain_group('developers').with(
      'gid'    => 2001,
      'ensure' => 'present'
    )}

  end


  context 'test hiera fixtures' do
    let(:facts) {{
      :operatingsystem => 'Debian',
      :osfamily => 'Debian',
      :lsbdistcodename => 'jessie',
      :lsbdistid => 'jessie',
      :puppetversion => Puppet.version,
    }}


  let(:hiera_data) { { :foo_message => "bar" } }

  it { should contain_notify("foo").with_message("bar") }
    # TODO: for some strange reason hiera doesn't work here
    #it { should contain_user('myuser').with(
    #  'uid' => 1000
    #)}
  end
end