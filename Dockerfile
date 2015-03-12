FROM hpess/jre
MAINTAINER Paul Cooke <paul.cooke@hp.com>, Karl Stoney <karl.stoney@hp.com>

ENV ES_PKG_NAME elasticsearch-1.4.4

# Install ElasticSearch.
RUN cd /opt && \
    https_proxy=http://proxy.sdc.hp.com:8080 wget --quiet https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
    tar xzf $ES_PKG_NAME.tar.gz && \
    rm -f $ES_PKG_NAME.tar.gz && \
    mv $ES_PKG_NAME elasticsearch

RUN mkdir -p /storage/data && \
    mkdir -p /storage/log && \
    mkdir -p /storage/work && \
    mkdir -p /storage/plugins

# Install Elasticsearch Head
#RUN /opt/elasticsearch/bin/plugin -install mobz/elasticsearch-head

# Expose ports.
EXPOSE 9200
EXPOSE 9300

# Setup the service and cookbooks
COPY services/* /etc/supervisord.d/
COPY cookbooks/ /chef/cookbooks/

# Setup the environment
ENV HPESS_ENV elasticsearch
ENV chef_node_name elasticsearch.docker.local
ENV chef_run_list elasticsearch
