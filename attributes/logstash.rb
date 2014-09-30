name = node['eas-logstash']['logstash']['name']
normal['logstash']['instance'][name]['elasticsearch_ip'] =
        node['eas-logstash']['es_server']
