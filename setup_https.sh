#!/bin/bash
# Quick HTTPS setup using ngrok

echo "Setting up HTTPS with ngrok..."

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "Installing ngrok..."
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    sudo apt update && sudo apt install ngrok -y
fi

echo ""
echo "=========================================="
echo "ngrok Setup Instructions"
echo "=========================================="
echo ""
echo "1. Sign up at https://dashboard.ngrok.com/signup (free)"
echo "2. Get your authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken"
echo "3. Run: ngrok config add-authtoken YOUR_TOKEN"
echo "4. Start tunnel: ngrok http 3000"
echo ""
echo "Then use the HTTPS URL ngrok gives you (e.g., https://abc123.ngrok.io)"
echo ""

