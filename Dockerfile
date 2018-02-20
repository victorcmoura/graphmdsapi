FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /graphmdsapi
WORKDIR /graphmdsapi
COPY Gemfile /graphmdsapi/Gemfile
COPY Gemfile.lock /graphmdsapi/Gemfile.lock
RUN bundle install
COPY . /graphmdsapi
