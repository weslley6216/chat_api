#!/bin/sh
set -e

echo "Initializing chat_api environment..."

# Adjust permissions for the application directory
echo "Adjusting permissions for /opt/app..."
chown -R appuser:appuser /opt/app
chmod -R 775 /opt/app

# Run Rails setup (migrations, etc.)
echo "Running Rails setup..."
bin/setup

# Start the Rails server
echo "Starting Rails server..."
exec rails server -b 0.0.0.0
