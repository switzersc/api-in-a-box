FROM ruby:2.1.2

# Run updates
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /api
WORKDIR /api

ADD /Gemfile /api/Gemfile
ADD /Gemfile.lock /api/Gemfile.lock
RUN bundle install

EXPOSE 4567

ADD . /api


CMD ["./deploy/deploy.sh"]