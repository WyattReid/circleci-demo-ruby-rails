FROM ruby:2.7.4

RUN apt-get update \
  && apt-get install -y nodejs postgresql-client

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN docker-compose build
RUN docker-compose up
RUN docker-compose run web bundle exec rails db:migrate:reset

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
