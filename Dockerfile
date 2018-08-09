FROM ruby:2.5
RUN apt-get update -qq

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get install -y nodejs
RUN apt-get update && apt-get install -y yarn
RUN apt-get install -y build-essential

RUN mkdir /sheedhet-server
WORKDIR /sheedhet-server
COPY Gemfile /sheedhet-server/Gemfile
COPY Gemfile.lock /sheedhet-server/Gemfile.lock
VOLUME /sheedhet-server
RUN bundle install
