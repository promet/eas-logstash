kibana_user 'kibana' do
  name 'kibana'
  group 'kibana'
  home '/opt/kibana'
end

kibana_install 'kibana' do
  user 'kibana'
  group 'kibana'
  install_dir node['kibana']['install_dir']
  install_type node['kibana']['install_type']
  action :create
end

template "#{node['kibana']['install_dir']}/current/config.js" do
  source 'config.js.erb'
  mode '0644'
  user 'kibana'
end
