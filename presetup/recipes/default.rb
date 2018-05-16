#
# Cookbook Name:: presetup_2016
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

### set timezone
#if node['kernel']['release'] == '3.14.35-28.38.amzn1.x86_64'
#bash 'make new link' do
#  code <<-EOF
#  rm /usr/bin/python
#  ln -s /usr/bin/python27 /usr/bin/python
#  EOF
#end
#end

#bash 'make new link' do
#  code <<-EOF
#  alternatives --set python /usr/bin/python2.7
#  EOF
#end

include_recipe "presetup::timezone"
include_recipe "presetup::sudo"

%w{
        mlocate
        telnet
        nss-pam-ldapd
        pam_ldap
}.each do |package_name|
  package "#{package_name}" do
    action :install
  end
end

execute "devtools" do
  user "root"
  command 'yum -y groupinstall "Development Tools"'
  action :run
end
