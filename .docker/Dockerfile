FROM ruby:3.0.1-alpine

RUN apk add --update --no-cache build-base postgresql-dev postgresql-client tzdata nodejs yarn bash git vim

ENV PATH /app/bin:$PATH

RUN mkdir /app
WORKDIR /app
