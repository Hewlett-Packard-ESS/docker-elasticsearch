FROM hpess/jre
MAINTAINER Paul Cooke <paul.cooke@hp.com>

ENV ES_PKG_NAME elasticsearch-1.4.1

# Install ElasticSearch.
RUN cd /opt && \
    wget --quiet https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
    tar xzf $ES_PKG_NAME.tar.gz && \
    rm -f $ES_PKG_NAME.tar.gz && \
    mv $ES_PKG_NAME elasticsearch

RUN mkdir -p /storage/data && \
    mkdir -p /storage/log && \
    mkdir -p /storage/work && \
    mkdir -p /storage/plugins

# Define default command.
#ENTRYPOINT ["/bin/sh"]
#CMD ["/opt/elasticsearch/bin/elasticsearch", "-Des.config=/storage/config/elasticsearch.yml"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

# Mount elasticsearch.yml config
COPY storage/config/elasticsearch.yml /storage/config/elasticsearch.yml

# Add the services
COPY services/* /etc/supervisord.d/
