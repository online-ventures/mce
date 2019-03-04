FROM ruby:2.5.3

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
RUN apt-get install -y nodejs

# an editor
RUN apt-get install -y vim

# app directory
ENV APP_HOME /mce
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# setup bundler
COPY Gemfile* $APP_HOME/
ENV GEM_HOME=/bundle
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile
ENV BUNDLE_JOBS=2
ENV BUNDLE_PATH=/bundle
ENV BUNDLE_BIN=/bundle/bin

# setup rails
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV RAILS_ENV=development

# for rails updates
ENV THOR_MERGE=vim

# app files
COPY . $APP_HOME

# Entrypoint
COPY scripts/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
