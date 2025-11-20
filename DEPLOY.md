# DigitalOcean Deployment Guide

## Step-by-Step Deployment

### 1. Prepare Your Files

On your local machine, make sure you have all these files:
- `server.py`
- `index.html`
- `requirements.txt`
- `deploy.sh`
- `nginx.conf`
- `info-collector.service`

### 2. Connect to DigitalOcean Droplet

```bash
ssh root@YOUR_DROPLET_IP
```

### 3. Upload Files to Server

**Option A: Using SCP (from your local machine)**
```bash
# Create directory on server first
ssh root@YOUR_DROPLET_IP "mkdir -p /root/info-collector"

# Upload all files
scp -r * root@YOUR_DROPLET_IP:/root/info-collector/
```

**Option B: Using Git (recommended)**
```bash
# On server
cd /root
git clone YOUR_REPO_URL
cd ethical_hacking
```

**Option C: Manual copy-paste**
- Use `nano` or `vi` to create files on server
- Copy content from your local files

### 4. Run Deployment Script

```bash
cd /root/info-collector  # or wherever your files are
chmod +x deploy.sh
./deploy.sh
```

The script will:
- ✅ Install Python, pip, nginx
- ✅ Create virtual environment
- ✅ Install dependencies
- ✅ Set up systemd service (auto-start on boot)
- ✅ Configure nginx reverse proxy
- ✅ Start all services

### 5. Configure Firewall (if needed)

DigitalOcean droplets usually have ufw enabled. Allow HTTP:

```bash
sudo ufw allow 80/tcp
sudo ufw allow 22/tcp  # SSH
sudo ufw status
```

### 6. Get Your Server IP

```bash
curl ifconfig.me
# or
hostname -I
```

### 7. Test the Deployment

1. **Check service status:**
   ```bash
   sudo systemctl status info-collector
   ```

2. **Check nginx:**
   ```bash
   sudo systemctl status nginx
   ```

3. **View logs:**
   ```bash
   sudo journalctl -u info-collector -f
   ```

4. **Test in browser:**
   Visit `http://YOUR_DROPLET_IP` - should see loading page

### 8. Send the Link

Send this link via Google Forms:
```
http://YOUR_DROPLET_IP
```

## Management Commands

### Service Management
```bash
# Start service
sudo systemctl start info-collector

# Stop service
sudo systemctl stop info-collector

# Restart service
sudo systemctl restart info-collector

# Check status
sudo systemctl status info-collector

# Enable auto-start on boot (already done by deploy.sh)
sudo systemctl enable info-collector

# View logs
sudo journalctl -u info-collector -f
```

### View Collected Data
```bash
# Via web interface
curl http://localhost/view

# Or view log file
cat /opt/info-collector/collected_data.json

# Or check service logs
sudo journalctl -u info-collector | grep "NEW DATA COLLECTED" -A 50
```

### Update Application
```bash
# After updating files
cd /opt/info-collector
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart info-collector
```

### Nginx Management
```bash
# Test nginx config
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

# Restart nginx
sudo systemctl restart nginx
```

## Troubleshooting

### Service won't start
```bash
# Check logs
sudo journalctl -u info-collector -n 50

# Check if port is in use
sudo netstat -tulpn | grep 5000

# Check file permissions
ls -la /opt/info-collector
```

### Can't access from outside
```bash
# Check firewall
sudo ufw status
sudo ufw allow 80

# Check nginx
sudo systemctl status nginx
sudo nginx -t

# Check if service is running
sudo systemctl status info-collector
```

### Permission errors
```bash
# Fix permissions
sudo chown -R $USER:$USER /opt/info-collector
sudo chmod +x /opt/info-collector/server.py
```

## Security Notes

- The service runs on port 5000 internally (not exposed)
- Nginx handles external traffic on port 80
- Consider adding SSL/HTTPS with Let's Encrypt for production
- The `/view` endpoint is public - consider adding authentication

## Optional: Add SSL/HTTPS

```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx

# Get certificate (replace with your domain)
sudo certbot --nginx -d yourdomain.com

# Auto-renewal is set up automatically
```

