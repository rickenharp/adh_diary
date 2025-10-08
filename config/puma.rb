# frozen_string_literal: true

require "sentry-ruby"
#
# Environment and port
#
port ENV.fetch("HANAMI_PORT", 2300)
environment(ENV["HANAMI_ENV"] || ENV["APP_ENV"] || ENV["RACK_ENV"] || "development")

#
# Threads within each Puma/Ruby process (aka worker)
#

# Configure the minimum and maximum number of threads to use to answer requests.
max_threads_count = ENV.fetch("HANAMI_MAX_THREADS", 5)
min_threads_count = ENV.fetch("HANAMI_MIN_THREADS") { max_threads_count }

threads min_threads_count, max_threads_count

#
# Workers (aka Puma/Ruby processes)
#

puma_concurrency = Integer(ENV.fetch("HANAMI_WEB_CONCURRENCY", 0))
puma_cluster_mode = puma_concurrency > 1

# How many worker (Puma/Ruby) processes to run.
# Typically this is set to the number of available cores.
workers puma_concurrency

Sentry.init do |config|
  config.breadcrumbs_logger = [:sentry_logger, :http_logger]
  # Add data like request headers and IP for accounts, if applicable;
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true
  config.environment = @options[:environment].to_sym
end

lowlevel_error_handler do |e, env, status|
  if status == 400
    message = "The server could not process the request due to an error, such as an incorrectly typed URL, malformed syntax, or a URL that contains illegal characters.\n"
  else
    message = "An error has occurred, and engineers have been informed. Please reload the page.\n"
    Sentry.capture_exception(e)
  end

  [status, {}, [message]]
end

#
# Cluster mode (aka multiple workers)
#

if puma_cluster_mode
  # Preload the application before starting the workers. Only in cluster mode.
  preload_app!

  # Code to run immediately before master process forks workers (once on boot).
  #
  # These hooks can block if necessary to wait for background operations unknown
  # to puma to finish before the process terminates. This can be used to close
  # any connections to remote servers (database, redis, …) that were opened when
  # preloading the code.
  before_fork do
    Hanami.shutdown
  end
end
