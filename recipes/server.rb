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

include_recipe 'java::default'
include_recipe 'curl::default'
include_recipe 'java::default'
include_recipe 'elasticsearch'

name = 'server'

Chef::Application.fatal!("attribute hash node['logstash']['instance']['#{name}'] must exist.") if node['logstash']['instance'][name].nil?

# these should all default correctly.  listing out for example.
logstash_instance name do
  action            :create
end

es_ip = ::Logstash.service_ip(node, name, 'elasticsearch')

Chef::Log.info("ElasticSearch IP: #{es_ip}")

logstash_service name do
  action      [:enable]
end

my_templates = node['logstash']['instance'][name]['config_templates']

if my_templates.nil?
  my_templates = {
    'output_elasticsearch' => 'config/output_elasticsearch.conf.erb',
    'input_syslog' => 'config/input_syslog.conf.erb'
  }
end

logstash_config name do
  templates my_templates
  action [:create]
  variables(
    elasticsearch_ip: es_ip
  )
  notifies :restart, "logstash_service[#{name}]"
end

include_recipe 'kibana'

