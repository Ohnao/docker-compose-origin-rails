FROM ruby:2.3.7
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /product_name
WORKDIR /product_name
ADD Gemfile /product_name/Gemfile
ADD Gemfile.lock /product_name/Gemfile.lock
RUN bundle install
ADD ./product_name
