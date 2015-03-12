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

template '/storage/config/elasticsearch.yml' do
  source    'elasticsearch.yml.erb'
  variables config 
  owner     'docker'
  group     'docker'
  action    :create
end
