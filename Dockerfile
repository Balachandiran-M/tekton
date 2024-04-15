# Use a smaller base image
FROM ruby:3.3.0-alpine

WORKDIR /app

# Install necessary dependencies
RUN apk update && apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs

# Install Bundler
RUN gem install bundler -v '2.5.7'

# Copy Gemfile and Gemfile.lock separately to optimize caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config set --local without 'development test' && bundle install

# Install Rails
RUN gem install rails -v '7.1.3.2'

# Copy application files
COPY . .

# Expose port
EXPOSE 3000

# Command to run the server
CMD ["sh", "-c", "rm -f tmp/pids/server.pid && rails db:create  && rails db:migrate && rails server -b '0.0.0.0'"]
