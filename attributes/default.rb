default['eas-logstash']['logstash']['name'] = 'server'

default['eas-logstash']['es_server'] = '127.0.0.1'
default['eas-logstash']['es_port'] = '9200'
default['eas-logstash']['webserver_hostname'] = node.name
default['eas-logstash']['webserver_listen'] = node['ipaddress']
default['eas-logstash']['webserver_aliases'] = [node['ipaddress']]
default['eas-logstash']['webserver_port'] = 80
default['eas-logstash']['webserver_scheme'] = 'http://'
default['eas-logstash']['web_dir'] = '/opt/kibana/current'
default['eas-logstash']['es_scheme'] = 'http://'

default['eas-logstash']['nginx']['ssl'] = false
# The path to the SSL certificate file.
default['eas-logstash']['nginx']['ssl_certificate']     = nil

default['eas-logstash']['nginx']['passwd'] = true
default['eas-logstash']['nginx']['htpasswd_file'] = '/etc/nginx/conf.d/kibana_user'

default['eas-logstash']['nginx']['client_max_body'] = '50M'

# The port on which to bind nginx.
default['eas-logstash']['nginx']['listen_http']  = 80
# The HTTPS port on which to bind nginx.
default['eas-logstash']['nginx']['listen_https'] = 443
