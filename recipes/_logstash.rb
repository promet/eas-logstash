name = node['eas-logstash']['logstash']['name']
Chef::Log.info("Server Name: #{name}")
Chef::Application.fatal!("attribute hash node['logstash']['instance']['#{name}'] must exist.") if node['logstash']['instance'][name].nil?

# these should all default correctly.  listing out for example.
logstash_instance name do
  action :create
end

# needs grok to build filters
apt_package 'grok' do
  action :install
end

directory '/etc/pki/tls/certs' do
  recursive true
  user 'root'
  group 'root'
  mode 00655
  action :create
end

directory '/etc/pki/tls/private' do
  recursive true
  user 'root'
  group 'root'
  mode 00655
  action :create
end

es_ip = ::Logstash.service_ip(node, name, 'elasticsearch')

Chef::Log.info("ElasticSearch IP: #{es_ip}")

logstash_service name do
  action [:enable]
end

cookbook_file '/etc/pki/tls/private/logstash.key' do
  source 'logstash.key'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "logstash_service[#{name}]"
end

cookbook_file '/etc/pki/tls/certs/logstash.crt' do
  source 'logstash.crt'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "logstash_service[#{name}]"
end

basedir = "#{node['logstash']['instance']['default']['basedir']}/#{name}"

cookbook_file "#{basedir}/etc/conf.d/input_syslog.conf" do
  source 'input_syslog.conf'
  owner node['logstash']['instance']['default']['user']
  group node['logstash']['instance']['default']['group']
  mode 0644
  notifies :restart, "logstash_service[#{name}]"
end

cookbook_file "#{basedir}/etc/conf.d/11_nginx_logstash.conf" do
  source '11_nginx_logstash.conf'
  owner node['logstash']['instance']['default']['user']
  group node['logstash']['instance']['default']['group']
  mode 0644
  notifies :restart, "logstash_service[#{name}]"
end

template "#{basedir}/etc/conf.d/output_elasticsearch.conf" do
  source 'output_elasticsearch.conf.erb'
  owner node['logstash']['instance']['default']['user']
  group node['logstash']['instance']['default']['group']
  action [:create]
  variables(
    elasticsearch_ip: es_ip
  )
  notifies :restart, "logstash_service[#{name}]"
end
