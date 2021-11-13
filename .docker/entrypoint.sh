#!/bin/sh
set -e

if [ "$1" != "bash" ]; then
  echo "Checking bundle..."
  bundle check 2>/dev/null || {
    echo "Running bundle install..."
    gem install bundler
    bundle
  }

  echo "Running migrations..."
  rake db:migrate 2>/dev/null || {
    echo "Setting up database..."
    rake db:prepare
    rake db:test:prepare
  }

  rm -f /app/tmp/pids/server.pid
fi

exec "$@"
