#!/bin/bash
# DigitalOcean Deployment Script
# Run this on your DigitalOcean server

set -e

echo "=========================================="
echo "DigitalOcean Deployment Script"
echo "=========================================="

# Update system
echo "[1/7] Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Python and pip
echo "[2/7] Installing Python and dependencies..."
sudo apt-get install -y python3 python3-pip python3-venv nginx

# Create application directory
echo "[3/7] Setting up application directory..."
APP_DIR="/opt/info-collector"
sudo mkdir -p $APP_DIR
sudo chown $USER:$USER $APP_DIR

# Copy files to application directory
echo "[4/7] Copying application files..."
# If running from current directory, copy files
if [ -f "server.py" ]; then
    cp server.py index.html requirements.txt $APP_DIR/ 2>/dev/null || true
else
    echo "Warning: Files not found in current directory. Make sure to run from project root."
fi
cd $APP_DIR

# Create virtual environment
echo "[5/7] Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Create systemd service
echo "[6/7] Creating systemd service..."
CURRENT_USER=${SUDO_USER:-$USER}
if [ "$CURRENT_USER" = "root" ]; then
    CURRENT_USER="root"
fi

sudo tee /etc/systemd/system/info-collector.service > /dev/null <<EOF
[Unit]
Description=Information Collector Service
After=network.target

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$APP_DIR
Environment="PATH=$APP_DIR/venv/bin"
ExecStart=$APP_DIR/venv/bin/python $APP_DIR/server.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Configure Nginx
echo "[7/7] Configuring Nginx..."
sudo tee /etc/nginx/sites-available/info-collector > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable Nginx site
sudo ln -sf /etc/nginx/sites-available/info-collector /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Reload systemd and start services
echo "Starting services..."
sudo systemctl daemon-reload
sudo systemctl enable info-collector
sudo systemctl restart info-collector
sudo systemctl restart nginx

# Get server IP
SERVER_IP=$(curl -s ifconfig.me || curl -s icanhazip.com || curl -s ipinfo.io/ip)

echo ""
echo "=========================================="
echo "DEPLOYMENT COMPLETE!"
echo "=========================================="
echo ""
echo "Server IP: $SERVER_IP"
echo "Your link: http://$SERVER_IP"
echo ""
echo "Service Status:"
echo "  Check: sudo systemctl status info-collector"
echo "  Logs:  sudo journalctl -u info-collector -f"
echo "  View data: http://$SERVER_IP/view"
echo ""
echo "=========================================="

