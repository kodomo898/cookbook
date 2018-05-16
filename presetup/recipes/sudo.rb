sudo_config="/etc/sudoers"

bash 'copy_sudo_config_original' do
  code <<-EOC
    cp #{sudo_config} #{sudo_config}.org
  EOC
  creates "#{sudo_config}.org"
end

settings = {
        'Defaults    requiretty' => '#Defaults    requiretty'
}

settings.each do |k, v|
  bash "set_sudo_config_#{v.split(' ').first}" do
    code <<-EOC
      sed -i -e "s/^#{k}/#{v}/g" #{sudo_config}
    EOC
    not_if "cat #{sudo_config} | grep '^#{v}'"
  end
end
