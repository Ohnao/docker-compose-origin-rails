FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /product_name
WORKDIR /product_name
ADD Gemfile /product_name/Gemfile
ADD Gemfile.lock /product_name/Gemfile.lock
RUN bundle install
ADD . /product_name
