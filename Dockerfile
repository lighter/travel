FROM ruby:2.3

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    apt-get install -y vim

RUN mkdir /myapp
WORKDIR /myapp
COPY ./travel_code/Gemfile ./travel_code/Gemfile.lock ./
RUN bundle install

COPY ./travel_code ./
