normal['elasticsearch']['version'] = '1.3.2'
normal['elasticsearch']['filename'] = "elasticsearch-#{node['elasticsearch']['version']}.tar.gz"
normal['elasticsearch']['download_url'] = [node['elasticsearch']['host'], node['elasticsearch']['repository'], node['elasticsearch']['filename']].join('/')
