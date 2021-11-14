#!/bin/bash

# Context info
echo "Entrypoint starting directory: $(pwd)"
echo "Rails environment: $RAILS_ENV"

# Database migrations
echo "Running db:migrate"
rails db:migrate

# Copy public assets to nginx
if [ -d "/mnt/html" ]; then
  cp -r public/* /mnt/html/
fi

echo "Start puma server"
puma -C config/puma.rb
