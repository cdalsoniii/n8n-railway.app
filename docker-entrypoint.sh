#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if a custom path for the N8N data folder has been set
if [ -n "$N8N_CUSTOM_EXTENSIONS" ]; then
    # Copy custom nodes
    cp -R $N8N_CUSTOM_EXTENSIONS/* /home/node/.n8n/
fi

# Initialize the database
#n8n init

# Run n8n
exec n8n start
