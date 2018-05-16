template '/etc/timezone' do
  source 'timezone.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Remove any pre-existing time zone file.
file '/etc/localtime' do
  action :delete
  only_if { ::File.exists?('/etc/localtime') && !::File.symlink?('/etc/localtime') }
end

# Symlink the correct time zone file.
link '/etc/localtime' do
  filename = "/usr/share/zoneinfo/#{node[:timezone][:area]}/#{node[:timezone][:zone]}"
  to filename
  not_if { ::File.symlink?('/etc/localtime') && ::File.readlink('/etc/localtime') == filename }
  notifies :restart, "service[crond]", :immediately
end

service "crond" do
  supports :start => true, :restart => true, :enable => true
end
