FROM ruby:latest

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential libpq-dev
RUN apt-get install -y nodejs less vim aptitude

ENV APP_HOME /k_ordered_flake
ENV PORT 3000

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD . $APP_HOME/

RUN bundle install

EXPOSE $PORT
