FROM ruby:3.0.1-alpine

RUN apk add --update --no-cache build-base postgresql-dev postgresql-client tzdata nodejs yarn bash git vim

ENV PATH /app/bin:$PATH

RUN mkdir /app
WORKDIR /app

ENV RAILS_ENV production
ENV RACK_ENV production

COPY Gemfile* $APP_HOME/
RUN bundle install --jobs 10 --retry 5 --without development test

COPY . $APP_HOME

RUN rails assets:precompile

COPY ./config/docker/app/entrypoint.sh /usr/local/bin
ENTRYPOINT ["entrypoint.sh"]
