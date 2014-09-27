default['logstash']['instance']['server']
default['logstash']['instance']['server']['elasticsearch_ip'] = '127.0.0.1'

default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'

normal['elasticsearch']['version'] = '1.3.2'
normal['elasticsearch']['filename'] = "elasticsearch-#{node.elasticsearch['version']}.tar.gz"
normal['elasticsearch']['download_url'] = [node.elasticsearch['host'], node.elasticsearch['repository'], node.elasticsearch['filename']].join('/')

normal['kibana']['version'] = '3'
normal['kibana']['kibana3_version'] = '3.1.0'
