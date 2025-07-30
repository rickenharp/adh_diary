#!/bin/sh

mkdir -p log public/assets
# Install base packages
ruby -r'open-uri' -e 'URI.open("https://deb.nodesource.com/setup_lts.x"){ File.write("nodesource_setup.sh", it.read)}' && bash nodesource_setup.sh
apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y curl libjemalloc2 sqlite3 nodejs pgloader postgresql-client libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives