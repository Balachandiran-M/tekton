# Stage 1: Build dependencies
FROM ruby:3.3.0-alpine as builder

# Install build dependencies
RUN apk update && apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock separately to optimize caching
COPY Gemfile Gemfile.lock ./

# Install Bundler and dependencies
RUN gem install bundler -v '2.5.7' && bundle config set --local without 'development test' && bundle install

# Stage 2: Final image
FROM ruby:3.3.0-alpine

# Install runtime dependencies
RUN apk update && apk add --no-cache \
    postgresql-client \
    nodejs

# Set working directory
WORKDIR /app

# Copy installed gems from the builder stage
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Copy application files
COPY . .

# Install Rails
RUN gem install rails -v '7.1.3.2'

# Expose port
EXPOSE 3000

# Command to run the server
CMD ["sh", "-c", "rm -f tmp/pids/server.pid && rails db:create && rails db:migrate && rails server -b '0.0.0.0'"]

