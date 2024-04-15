#!/bin/sh

# Check if the Rails server is already running
if [ -f /app/tmp/pids/server.pid ]; then
  echo "Rails server is already running."
else
  # Start the Rails server
  echo "Starting Rails server..."
  rails server -b "0.0.0.0" &
fi

# Wait for a few seconds before running migrations
sleep 10

# Run migrations
echo "Running database migrations..."
bin/rails db:migrate

# Keep the container running
tail -f /dev/null
