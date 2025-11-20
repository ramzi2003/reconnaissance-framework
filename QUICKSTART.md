# 🚀 Quick Start - DigitalOcean Deployment

## One-Command Deployment

1. **SSH into your DigitalOcean droplet:**
   ```bash
   ssh root@YOUR_DROPLET_IP
   ```

2. **Upload files and deploy:**
   ```bash
   # Option 1: If you have files locally, upload them:
   # (Run this from your local machine)
   scp -r * root@YOUR_DROPLET_IP:/root/info-collector/
   
   # Then on server:
   ssh root@YOUR_DROPLET_IP
   cd /root/info-collector
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Get your server IP:**
   ```bash
   curl ifconfig.me
   ```

4. **Send the link via Google Forms:**
   ```
   http://YOUR_DROPLET_IP
   ```

5. **View collected data:**
   ```
   http://YOUR_DROPLET_IP/view
   ```

## That's it! 🎉

The service will:
- ✅ Start automatically on boot
- ✅ Restart automatically if it crashes
- ✅ Run in the background (no need to keep terminal open)
- ✅ Collect IP, geolocation, and system info

## Quick Commands

```bash
# View logs in real-time
sudo journalctl -u info-collector -f

# Check if running
sudo systemctl status info-collector

# Restart if needed
sudo systemctl restart info-collector
```

## Need Help?

See `DEPLOY.md` for detailed instructions and troubleshooting.

