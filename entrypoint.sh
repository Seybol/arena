#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
until pg_isready -h db -p 5432; do
  echo "Waiting for database to be ready..."
  sleep 2
done

# Create database if it doesn't exist
bundle exec rails db:prepare

# Run database migrations
bundle exec rails db:migrate

# Load seed data
bundle exec rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
