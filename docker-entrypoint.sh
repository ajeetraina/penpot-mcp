#!/bin/bash
set -e

echo "Starting Penpot MCP Server..."

# Validate required environment variables
if [ -z "$PENPOT_USERNAME" ]; then
    echo "Error: PENPOT_USERNAME environment variable is required"
    exit 1
fi

if [ -z "$PENPOT_PASSWORD" ]; then
    echo "Error: PENPOT_PASSWORD environment variable is required"
    exit 1
fi

# Set default values for optional variables
export PENPOT_API_URL=${PENPOT_API_URL:-"https://design.penpot.app/api"}
export PORT=${PORT:-5000}
export DEBUG=${DEBUG:-false}

echo "Configuration:"
echo "  API URL: $PENPOT_API_URL"
echo "  Port: $PORT"
echo "  Debug: $DEBUG"
echo "  Username: $PENPOT_USERNAME"

# Execute the main command
exec "$@"
