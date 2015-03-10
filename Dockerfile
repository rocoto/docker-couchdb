FROM debian:wheezy
MAINTAINER Lupo Montero

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends build-essential
RUN apt-get install -y --no-install-recommends libicu-dev
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev
RUN apt-get install -y --no-install-recommends libmozjs185-dev

RUN apt-get install -y --no-install-recommends \
  erlang-base-hipe \
  erlang-dev \
  erlang-manpages \
  erlang-eunit \
  erlang-nox 

RUN apt-get install -y wget sudo

RUN cd /tmp \
  && wget http://mirror.cc.columbia.edu/pub/software/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz \
  && tar xvzf apache-couchdb-*

RUN cd /tmp/apache-couchdb-* && ./configure && make && make install

RUN useradd --system -M \
  --home /data \
  --shell /bin/bash \
  --user-group \
  --comment "CouchDB Administrator" \
  couchdb

COPY ./local.ini /local.ini
COPY ./entrypoint.sh /entrypoint.sh

VOLUME ["/data"]
EXPOSE 5984

ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchdb"]

