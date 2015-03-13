![Elasticsearch](/elasticsearch.png?raw=true "Elasticsearch")

This container builds on hpess/jre by adding elasticsearch. Currently installing elasticsearch 1.4.4

## Use
Here's an example docker-compose file.  node_name and cluster_name are not required.
```
elasticsearch:
  image: hpess/elasticsearch
  hostname: elasticsearch
  environment:
    node_name: 'test_node'
    cluster_name: 'test_cluster'
  ports:
    - "9200:9200/tcp" 
    - "9300:9300/tcp" 
```
## Backing up
You can configure backups quite easily with the `elasticsearch_backup` environment variable.  You must follow the exact syntax of: `name:crontab:location:indices`, for example to back up the kibana index every 30 minutes you would use `my_kibana_backup:30 * * * *:/storage/backup/kibana:.kibana`.

You can backup all indicies by omitting the final `.kibana` part, for example: `all:30 * * * *:/storage/backup/all`.

Remember, backups are deltad, please read: [Backing up your Cluster](http://www.elastic.co/guide/en/elasticsearch/guide/current/backing-up-your-cluster.html).

## License
This docker application is distributed unter the MIT License (MIT).

Elasticsearch itself is licenced under the [Apache](https://github.com/elastic/elasticsearch/blob/master/LICENSE.txt) License.
