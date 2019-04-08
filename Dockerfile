# FROM alpine:edge
FROM debian:jessie-slim
MAINTAINER Benjamin Roques <benjamin.roques@ucdconnect.ie>

# RUN apk add 'tor' --no-cache \
#   --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
#   --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
#   --allow-untrusted haproxy ruby privoxy squid

# RUN apk --update add --virtual build-dependencies ruby-bundler ruby-dev  \
#   && apk add ruby-nokogiri --update-cache --repository http://dl-4.alpinelinux.org/alpine/v3.3/main/ \
#   && gem install --no-ri --no-rdoc socksify \
#   && apk del build-dependencies \
#   && rm -rf /var/cache/apk/*

RUN apt-get update
RUN apt-get install -y ruby-nokogiri ruby-dev && gem install --no-ri --no-rdoc socksify
RUN apt-get install -y privoxy haproxy tor

ADD haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb
ADD privoxy.cfg.erb /usr/local/etc/privoxy.cfg.erb

ADD passwords /usr/local/etc/passwords
ADD squid.conf.erb /usr/local/etc/squid.conf.erb

ADD start.rb /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/start.rb

EXPOSE 2090 8118 5566 8119 8117

CMD ruby /usr/local/bin/start.rb
