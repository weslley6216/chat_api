#!/bin/sh
set -e

# Run the Rails setup (migrations, gems, etc.)
bin/setup

# Start the Rails server
exec rails server -b 0.0.0.0
