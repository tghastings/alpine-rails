FROM alpine:3.8

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev libgcrypt-dev tzdata yaml-dev sqlite-dev postgresql-dev mysql-dev" \
    RUBY_PACKAGES="ruby ruby-io-console ruby-bigdecimal ruby-etc ruby-json yaml nodejs" \
    RAILS_VERSION="5.0.7"

RUN \
  apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES \
  && rm -f /var/cache/apk/* \
  && gem install -N bundler

RUN gem install -N pkg-config -- --use-system-libraries \ 
&& gem install -N nokogiri -- --use-system-libraries \
&& gem install -N rails --version "$RAILS_VERSION" \
&& echo 'gem: --no-document' >> ~/.gemrc \
&& cp ~/.gemrc /etc/gemrc \
&& chmod uog+r /etc/gemrc \
&& bundle config --global build.nokogiri "--use-system-libraries" \
&& bundle config --global build.nokogumbo "--use-system-libraries" \
&& find / -type f -iname \*.apk-new -delete \
&& rm -rf /var/cache/apk/* \
&& rm -rf /usr/lib/lib/ruby/gems/*/cache/* \
&& rm -rf ~/.gem

EXPOSE 3000
