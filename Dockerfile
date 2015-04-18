FROM debian:jessie
MAINTAINER Lupo Montero

#
# Install dependencies, CouchDB from source and cleanup.
#
# Fat command for slim image ;-)
# See: http://mervine.net/notes/docker-tips
#
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    libicu-dev \
    libcurl4-openssl-dev \
    libmozjs185-dev \
    erlang-base-hipe \
    erlang-dev \
    erlang-manpages \
    erlang-eunit \
    erlang-nox \
    wget \
    sudo \
  && wget http://mirror.cc.columbia.edu/pub/software/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz \
  && tar xvzf apache-couchdb-* \
  && cd apache-couchdb-* && ./configure && make && make install \
  && cd - && rm -rf apache-couchdb-* \
  && apt-get remove -y \
    build-essential \
    erlang-dev \
    erlang-manpages \
    wget \
  && apt-get autoremove -y \
  && apt-get clean

RUN useradd --system -M \
  --home /data \
  --shell /bin/bash \
  --user-group \
  --comment "CouchDB Administrator" \
  couchdb

ADD ./local.ini /local.ini
ADD ./entrypoint.sh /entrypoint.sh

VOLUME ["/data"]
EXPOSE 5984
ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchdb"]

