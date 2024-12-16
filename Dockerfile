# syntax = docker/dockerfile:1

# Base image for Ruby
ARG RUBY_VERSION=3.1.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Set working directory
WORKDIR /rails

# Install base packages, PostgreSQL development libraries, and Node.js
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips sqlite3 libpq-dev build-essential nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Copy application files
COPY Gemfile Gemfile.lock ./

# Install application dependencies
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy the rest of the application code
COPY . .

# Fix permissions on rails binary
RUN chmod +x ./bin/rails

# Precompile assets for production
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Expose port 3000
EXPOSE 3000

# Fix permissions on rails binary and docker-entrypoint
RUN chmod +x ./bin/rails ./bin/docker-entrypoint

# Set the entry point
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Default command to run the Rails server
CMD ["./bin/rails", "server"]
