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

## License
This docker application is distributed unter the MIT License (MIT).

Elasticsearch itself is licenced under the [Apache](https://github.com/elastic/elasticsearch/blob/master/LICENSE.txt) License.
