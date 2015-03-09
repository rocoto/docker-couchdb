FROM ubuntu:14.04.1
MAINTAINER Lupo Montero

VOLUME ["/data"]
EXPOSE 5984

RUN sudo apt-get update -y
RUN sudo apt-get install -y build-essential erlang-base-hipe erlang-dev \
  erlang-manpages erlang-eunit erlang-nox libicu-dev libmozjs185-dev \
  libcurl4-openssl-dev wget

RUN cd /tmp \
  && wget http://mirror.cc.columbia.edu/pub/software/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz \
  && tar xvzf apache-couchdb-*

RUN cd /tmp/apache-couchdb-* && ./configure && make && sudo make install

RUN adduser --system \
  --home /usr/local/var/lib/couchdb \
  --shell /bin/bash \
  --group --gecos \
  "CouchDB Administrator" couchdb

COPY ./couch.ini /usr/local/etc/couchdb/local.d/local.ini
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchdb"]
