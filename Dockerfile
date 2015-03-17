FROM hpess/jre:master
MAINTAINER Karl Stoney <karl.stoney@hp.com>

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
RUN /opt/elasticsearch/bin/plugin -install mobz/elasticsearch-head && \
    /opt/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf

# Set the correct user permissions on the files
RUN chown -R docker:docker /opt/elasticsearch && \
    chown -R docker:docker /storage

# Install cronie for backups
RUN yum -y -q install cronie && \
    yum -y -q clean all && \
    mkdir -p /var/lock/subsys && \
    sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond

# Get rid of any cron jobs that are there by default
RUN rm -f /etc/cron.daily/* && \
    rm -f /etc/cron.hourly/* && \
    rm -f /etc/cron.monthly/* && \
    rm -f /etc/cron.weekly/* && \
    rm -f /etc/cron.d/*

# Performance Tweaks
RUN echo "\* soft nofile 64000" >> /etc/security/limits.conf
RUN echo "\* hard nofile 75000" >> /etc/security/limits.conf
RUN echo vm.max_map_count=262144 > /etc/sysctl.d/max_map_count.conf
RUN echo vm.swappiness=0 > /etc/sysctl.d/swappiness.conf
ENV ES_HEAP_SIZE 1g

# Expose ports.
EXPOSE 9200 9300

# Setup the service and cookbooks
COPY cookbooks/ /chef/cookbooks/
COPY services/* /etc/supervisord.d/

# Setup the environment
ENV HPESS_ENV elasticsearch
ENV chef_node_name elasticsearch.docker.local
ENV chef_run_list elasticsearch
