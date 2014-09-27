#
# Recipe:: default
#
# Copyright (C) 2014 opscale
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt'
include_recipe 'java::default'
include_recipe 'curl::default'
include_recipe 'java::default'
include_recipe 'elasticsearch'

name = 'server'

Chef::Application.fatal!("attribute hash node['logstash']['instance']['#{name}'] must exist.") if node['logstash']['instance'][name].nil?

# needs grok to build filters
apt_package 'grok' do
  action :install
end

# these should all default correctly.  listing out for example.
logstash_instance name do
  action :create
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

cookbook_file "#{basedir}/etc/conf.d/11_simple_nginx.conf" do
  source '11_simple_nginx.conf'
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

include_recipe 'eas-logstash::_nginx'

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
