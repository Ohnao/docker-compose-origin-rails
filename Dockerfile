FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /rails-test
WORKDIR /rails-test
ADD Gemfile /rails-test/Gemfile
ADD Gemfile.lock /rails-test/Gemfile.lock
RUN bundle install
ADD . /rails-test
