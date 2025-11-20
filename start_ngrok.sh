#!/bin/bash
# Start ngrok with config file

# Create correct config directory for ngrok v3
mkdir -p ~/.config/ngrok

# Check if config exists, if not copy from repo
if [ ! -f ~/.config/ngrok/ngrok.yml ]; then
    if [ -f ngrok.yml ]; then
        cp ngrok.yml ~/.config/ngrok/ngrok.yml
        echo "Config file created at ~/.config/ngrok/ngrok.yml"
        
        # Check if authtoken needs to be set
        if grep -q "YOUR_NGROK_AUTHTOKEN_HERE" ~/.config/ngrok/ngrok.yml; then
            echo "IMPORTANT: Edit ~/.config/ngrok/ngrok.yml and add your authtoken!"
            echo "Run: nano ~/.config/ngrok/ngrok.yml"
            exit 1
        fi
    else
        echo "Error: ngrok.yml not found in current directory"
        exit 1
    fi
fi

# Verify config
ngrok config check

# Start ngrok using config
echo "Starting ngrok tunnel..."
ngrok start web

