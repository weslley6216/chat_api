#!/bin/sh
set -e

echo "Initializing chat_api environment..."

# Adjust permissions for the application directory
mkdir -p tmp/pids tmp/cache tmp/sockets log db
chown -R appuser:appuser tmp log db

# Run Rails setup (migrations, etc.)
echo "Running Rails setup..."
bin/setup

# Start the Rails server
echo "Starting Rails server..."
rm -f tmp/pids/server.pid

exec rails server -b 0.0.0.0
