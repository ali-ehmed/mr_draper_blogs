FROM ruby:2.5.3

# Installing Postgres
RUN apt-get update -qq && apt-get install -y libpq-dev postgresql-contrib tzdata

# Yarn and NodeJS Installation
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get install -y nodejs
RUN apt-get update && apt-get install -y yarn

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Copy dependencies for Node.js and instance the packages.
# Again, being separate means this will cache.
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN yarn install --check-files
RUN yarn check --integrity

# Copy the main application.
COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.

# Note: Rails does a lot of checkups on Yarn, a bit too much. Best is to disable this:
# config.webpacker.check_yarn_integrity = false in config/environments/development.rb
CMD ["rails", "server", "-b", "0.0.0.0"]