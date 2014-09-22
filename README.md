# eas-logstash-cookbook

This cookbook create a single server elasticsearch/logstash/kibana server. Setup to communicate via ssl with rsyslog clients.  

## Supported Platforms

Ubuntu 14.04 (may work on other versions of Ubuntu, but target release is 14.04)

## Attributes
```
default['logstash']['instance']['server']
default['logstash']['instance']['server']['elasticsearch_ip'] = '127.0.0.1'

default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'

normal['elasticsearch']['version']       = "1.3.2"
normal['elasticsearch']['filename']      = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
normal['elasticsearch']['download_url']  = [node.elasticsearch[:host], node.elasticsearch[:repository], node.elasticsearch[:filename]].join('/')
```

## Usage

This cookbook should part of the loghost role, so a node that runs the eas-base cookbook can find a logstash server via chef-search. In a local environment using test kitchen with chef-solo the loghost will have the IP address 33.33.33.10 assigned to it. 

To bootstrap a logstash server on AWS you may run a knife command like:

```
knife ec2  server create --flavor t2.micro --image  ami-864d84ee --associate-public-ip --subnet "SUBNET" --ssh-key KEYPAIR_NAME --run-list "role[loghost]" --security-group-ids SECURITY_GROUP_ID -x ubuntu -i PATH_TO_KEY_PAIR_FILE
```
When setting up the AWS security group, make sure that port 5601 is enabled to allow access to the kibana UI. Also allow all traffic on the local subnet.

## Security

Currently the certificate and the key necessary for the encrypted communication between the logstash host and the rsyslog clients are part of this repository. This is acceptable for testing, but will be changed for production. 

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
