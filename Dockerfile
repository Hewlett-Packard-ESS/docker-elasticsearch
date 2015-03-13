FROM hpess/jre
MAINTAINER Paul Cooke <paul.cooke@hp.com>, Karl Stoney <karl.stoney@hp.com>

ENV ES_PKG_NAME elasticsearch-1.4.4

# Install ElasticSearch.
RUN cd /opt && \
    wget --quiet https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
    tar xzf $ES_PKG_NAME.tar.gz && \
    rm -f $ES_PKG_NAME.tar.gz && \
    mv $ES_PKG_NAME elasticsearch

RUN mkdir -p /storage/data && \
    mkdir -p /storage/log && \
    mkdir -p /storage/work 

# Install Elasticsearch Head
RUN /opt/elasticsearch/bin/plugin -install mobz/elasticsearch-head

# Set the correct user permissions on the files
RUN chown -R docker:docker /opt/elasticsearch && \
    chown -R docker:docker /storage

# Install cronie for backups
RUN yum -y install cronie && \
    yum -y clean all

# Expose ports.
EXPOSE 9200
EXPOSE 9300

# Setup the service and cookbooks
COPY cookbooks/ /chef/cookbooks/
COPY services/* /etc/supervisord.d/

# Setup the environment
ENV HPESS_ENV elasticsearch
ENV chef_node_name elasticsearch.docker.local
ENV chef_run_list elasticsearch
