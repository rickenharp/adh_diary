# syntax=docker/dockerfile:1
# check=error=true

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.5-slim
FROM docker.io/library/ruby:${RUBY_VERSION} AS base

# Hanami app lives here
WORKDIR /hanami

RUN mkdir -p log public/assets

# Install base packages
COPY setup_docker_base.sh /
RUN  /setup_docker_base.sh

# Set production environment
ENV HANAMI_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git


# Copy application code
COPY . .

RUN npm install
# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN env WITHINGS_CLIENT_SECRET=1 WITHINGS_CLIENT_ID=1 SESSION_SECRET=1 bundle exec hanami assets compile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /hanami /hanami

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 hanami && \
    useradd hanami --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R hanami:hanami log public config/db
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/hanami/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime

CMD ["bundle", "exec", "hanami", "server"]
