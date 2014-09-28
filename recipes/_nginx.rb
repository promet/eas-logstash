include_recipe 'nginx'

template "#{node['nginx']['dir']}/sites-available/kibana" do
  source 'nginx.erb'
  notifies :reload, 'service[nginx]'
  variables(
    'ssl' => node['eas-logstash']['nginx']['ssl'],
    'passwd' => node['eas-logstash']['nginx']['passwd'],
    'htpasswd_file' => node['eas-logstash']['nginx']['htpasswd_file'],
    'listen_http' => node['eas-logstash']['nginx']['listen_http'],
    'listen_https' => node['eas-logstash']['nginx']['listen_https'],
    'client_max_body' => node['eas-logstash']['nginx']['client_max_body'],
    'es_server' => node['eas-logstash']['es_server'],
    'es_port' => node['eas-logstash']['es_port'],
    'server_name' => node['eas-logstash']['webserver_hostname'],
    'server_aliases' => node['eas-logstash']['webserver_aliases'],
    'kibana_dir' => node['eas-logstash']['web_dir'],
    'listen_address' => node['eas-logstash']['webserver_listen'],
    'listen_port' => node['eas-logstash']['webserver_port'],
    'es_scheme' => node['eas-logstash']['es_scheme']
  )
end

kibana_login = data_bag_item('users', 'kibana_user')

file node['eas-logstash']['nginx']['htpasswd_file'] do
  content "#{kibana_login['id']}:#{kibana_login['password']}"
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, 'service[nginx]'
end

nginx_site 'kibana'
