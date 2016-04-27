FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs

RUN mkdir /api
WORKDIR /api

ENV RACK_ENV=docker
ENV RAILS_ENV=docker
ENV DEVISE_SECRET_KEY=I_AM_INSECURE_CHANGE_ME
ENV SECRET_KEY_BASE=I_AM_INSECURE_CHANGE_ME

# If you are not using Docker compose, you need to set your database connection info here
# ENV DATABASE_URL=postgres://user:pass@hostname:5432/database_name

COPY Gemfile /api/
COPY Gemfile.lock /api/

COPY . /api/

RUN bundle install --without development test
RUN DB_ADAPTER=nulldb bundle exec rake assets:precompile

# Note: Don't forget you have to run the migrations manually, by SSH'ing
# into the web server and running the following:
# rake db:migrate && rake db:seed && rake setup:demo

EXPOSE 3000

CMD bundle exec rails s -p 3000 -b '0.0.0.0'
