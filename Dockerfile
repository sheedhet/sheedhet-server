FROM ruby:2.6-alpine
RUN apk add --no-cache --update build-base \
                                linux-headers \
                                git \
                                nodejs \
                                yarn \
                                tzdata

RUN mkdir /sheedhet-server
WORKDIR /sheedhet-server
COPY Gemfile /sheedhet-server/Gemfile
COPY Gemfile.lock /sheedhet-server/Gemfile.lock
RUN bundle install
COPY . /sheedhet-server

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
