directory '/storage/config' do
	owner 'docker'
	group 'docker'
	action :create
	recursive true
end

config = { 
	:node_name    => ENV['node_name'], 
	:cluster_name => ENV['cluster_name'] 
}
config[:cluster_name] = 'cluster1' if config[:cluster_name].nil?

template '/storage/config/elasticsearch.yml' do
	source    'elasticsearch.yml.erb'
	variables config 
	owner     'docker'
	group     'docker'
	action    :create_if_missing
end

backup=ENV['elasticsearch_backup']
if not backup.nil?
	backup=backup.split(',').map{|item| 
		item = item.split(':')
		item = {
			'name' => item[0],
			'cron' => item[1],
			'location' => item[2],
			'index' => item[3]
		}
		item
	}
end

cookbook_file 'cron' do
	source 'cron.service.conf'
	path   '/etc/supervisord.d/cron.service.conf'
	action :nothing
end

cookbook_file 'elasticsearch-logging-config' do
	source 'logging.yml'
	owner     'docker'
	group     'docker'
	path   '/storage/config/logging.yml'
	action :create_if_missing
end

template '/usr/local/bin/start_elasticsearch.sh' do
	source    'start_elasticsearch.sh.erb'
	mode	  '0755'
	action    :create
end

template '/usr/local/bin/backup_elasticsearch.sh' do
	source    'backup_elasticsearch.sh.erb'
	mode	  '0755'
	action    :create
	not_if { backup.nil? }
end

template '/etc/cron.d/elasticsearch_backup' do
	source    'cron_elasticsearch.erb'
	mode	  '0644'
	variables({
		"items" => backup
	})
	action    :create
	notifies  :create, 'cookbook_file[cron]', :delayed
	not_if { backup.nil? }
end
