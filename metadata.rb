name             'eas-logstash'
maintainer       'opscale'
maintainer_email 'cookbooks@opscale.com'
license          'Apache 2.0'
description      'Installs/Configures eas-logstash'
long_description 'Installs/Configures eas-logstash'
version          '0.1.0'

depends 'apt'
depends 'java'
depends 'curl'
depends 'elasticsearch'
depends 'logstash'
depends 'kibana'
