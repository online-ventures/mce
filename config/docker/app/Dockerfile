FROM ruby:2.6.1

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
# https://github.com/nodesource/distributions#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs

# an editor
RUN apt-get install -y vim

# app directory
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Production build
ENV RAILS_ENV production
ENV RACK_ENV production

# setup bundler
COPY Gemfile* $APP_HOME/
RUN bundle install --jobs 10 --retry 5 --without development test

# Document what port should be exposed
EXPOSE 3000

# Entrypoint
COPY ./config/docker/app/entrypoint.sh /usr/local/bin
ENTRYPOINT ["entrypoint.sh"]

# App files
COPY . $APP_HOME
