FROM ruby:2.2.5

MAINTAINER Shelby Switzer <shelbyswitzer@gmail.com>

# Run updates
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /api
WORKDIR /api

ADD /Gemfile /api/Gemfile
ADD /Gemfile.lock /api/Gemfile.lock
RUN bundle install

EXPOSE 4567

COPY ./data_processor/file_grabber.rb /tmp/file_grabber.rb


CMD bash ./deploy/start.sh
