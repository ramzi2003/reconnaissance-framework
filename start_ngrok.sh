#!/bin/bash
# Start ngrok with config file

# Check if config exists
if [ ! -f ~/.ngrok2/ngrok.yml ]; then
    echo "Creating ngrok config directory..."
    mkdir -p ~/.ngrok2
    
    # Copy config template
    if [ -f ngrok.yml ]; then
        cp ngrok.yml ~/.ngrok2/ngrok.yml
        echo "Config file created at ~/.ngrok2/ngrok.yml"
        echo "IMPORTANT: Edit ~/.ngrok2/ngrok.yml and add your authtoken!"
        echo "Run: nano ~/.ngrok2/ngrok.yml"
        exit 1
    else
        echo "Error: ngrok.yml not found in current directory"
        exit 1
    fi
fi

# Start ngrok using config
echo "Starting ngrok tunnel..."
ngrok start web

