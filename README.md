# eas-logstash-cookbook

This cookbook create a single server elasticsearch/logstash/kibana server. Setup to communicate via ssl with rsyslog clients. By default the cookbook will setup a Kibana 3 front-end with authentication. Authentication requires a data bag "kibana_user". A test example can be found [here](https://github.com/promet/eas-logstash/blob/master/test/integration/data_bags/users/kibana_user.json).

## Supported Platforms

Ubuntu 14.04 (may work on other versions of Ubuntu, but target release is 14.04)

## Attributes
```
default['logstash']['instance']['server']
default['logstash']['instance']['server']['elasticsearch_ip'] = '127.0.0.1'

default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'

normal['elasticsearch']['version'] = '1.3.2'
normal['elasticsearch']['filename'] = "elasticsearch-#{node['elasticsearch']['version']}.tar.gz"
normal['elasticsearch']['download_url'] = [node['elasticsearch']['host'], node['elasticsearch']['repository'], node['elasticsearch']['filename']].join('/')

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
default['eas-logstash']['nginx']['passwd'] = true
default['eas-logstash']['nginx']['htpasswd_file'] = '/etc/nginx/conf.d/kibana_user'

# The path to the SSL certificate file.
default['eas-logstash']['nginx']['ssl_certificate']     = nil
default['eas-logstash']['nginx']['client_max_body'] = '50M'

# The port on which to bind nginx.
default['eas-logstash']['nginx']['listen_http']  = 80
# The HTTPS port on which to bind nginx.
default['eas-logstash']['nginx']['listen_https'] = 443

normal['nginx']['default_site_enabled'] = false
normal['nginx']['install_method'] = 'package'
```

## Usage

This cookbook should be part of the loghost role, so a node that runs the eas-base cookbook can find a logstash server via chef-search. In a local environment using test kitchen with chef-solo the loghost will have the IP address 33.33.33.10 assigned to it. 

To bootstrap a logstash server on AWS you may run a knife command like:

```
knife ec2  server create --flavor t2.micro --image  ami-864d84ee --associate-public-ip --subnet "SUBNET" --ssh-key KEYPAIR_NAME --run-list "role[loghost]" --security-group-ids SECURITY_GROUP_ID -x ubuntu -i PATH_TO_KEY_PAIR_FILE
```
When setting up the AWS security group, make sure that port 5601 is enabled to allow access to the kibana UI. Also allow all traffic on the local subnet.

## Security

Currently the certificate and the key necessary for the encrypted communication between the logstash host and the rsyslog clients are part of this repository. This is acceptable for testing, but will be changed for production. 

Configuring security is handled by following default settings: 
```
default['eas-logstash']['nginx']['passwd'] = true
```
As set by default to `true`, a kibana user must authenticate. This setting also implies a proxy setup for the connection to elasticsearch.
```
default['eas-logstash']['nginx']['ssl'] = false
```
Not implemented yet. Enables ssl for client connections as well as the redirect from port 80 to port 443.

```
default['eas-logstash']['es_scheme'] = 'http://'
```
Not implemented yet. Enables ssl for elastic search connectivity.


### eas-logstash::default

Include `eas-logstash` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[eas-logstash::server]"
  ]
}
```

## License and Authors

Author:: opscale (<cookbooks@opscale.com>)
