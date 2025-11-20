# Information Collection Tool

This tool collects IP address, geolocation, and system information from anyone who clicks the link.

## 🚀 DigitalOcean Deployment (Recommended)

### Quick Deploy to DigitalOcean

1. **Connect to your DigitalOcean server:**
   ```bash
   ssh root@YOUR_DROPLET_IP
   ```

2. **Upload files to server:**
   ```bash
   # From your local machine, use SCP:
   scp -r * root@YOUR_DROPLET_IP:/root/info-collector/
   
   # Or use git:
   git clone YOUR_REPO_URL
   cd ethical_hacking
   ```

3. **Run deployment script:**
   ```bash
   cd /root/info-collector  # or wherever you uploaded files
   chmod +x deploy.sh
   ./deploy.sh
   ```

4. **Get your server IP and send the link:**
   ```bash
   curl ifconfig.me
   ```
   
   Send this link via Google Forms:
   ```
   http://YOUR_DROPLET_IP
   ```

The service will **automatically start on boot** and restart if it crashes!

### View Collected Data

- **Web interface:** `http://YOUR_DROPLET_IP/view`
- **Check logs:** `sudo journalctl -u info-collector -f`
- **Check status:** `sudo systemctl status info-collector`
- **Restart service:** `sudo systemctl restart info-collector`

## Local Development

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Run the Server
```bash
python server.py
```

### 3. Get Your Public IP
- On Windows: Visit https://whatismyipaddress.com/
- On Linux/Mac: Run `curl ifconfig.me`
- Or use: `curl https://api.ipify.org`

### 4. Send the Link
Send this link via Google Forms:
```
http://YOUR_PUBLIC_IP:5000
```

**Important:** Make sure port 5000 is open in your firewall/router if testing remotely.

## What It Collects

✅ **IP Address** - Always collected (server-side)  
✅ **Geolocation** - Browser GPS (if allowed) + IP-based geolocation (fallback)  
✅ **System Info** - OS, browser, screen resolution, timezone, language, etc.  
✅ **Network Info** - ISP, organization, AS number  

## View Collected Data

1. **Real-time**: Check the terminal/console where server is running
2. **Web interface**: Visit `http://localhost:5000/view`
3. **Log file**: Check `collected_data.json`

## Deployment Options

### Option 1: Local Network (Same WiFi)
- Use your local IP (e.g., `192.168.1.100:5000`)
- Works if target is on same network

### Option 2: Public Server
- Deploy to cloud (Heroku, Railway, Render, etc.)
- Or use ngrok for tunneling: `ngrok http 5000`

### Option 3: ngrok (Easiest for Testing)
```bash
# Install ngrok from https://ngrok.com
ngrok http 5000
# Use the ngrok URL (e.g., https://abc123.ngrok.io)
```

## Tips for Success

1. **Make link look trustworthy**: Use a URL shortener or custom domain
2. **Social engineering**: Make the message compelling ("Check this out!", "Important update", etc.)
3. **Timing**: The page shows "Loading..." then redirects to Google (looks harmless)
4. **Mobile-friendly**: Works on all devices (iPhone, Android, Windows, Linux, Mac)

## Expected Results

After target clicks, you'll get:
- ✅ Exact IP address
- ✅ Approximate geolocation (city-level from IP, precise from GPS if allowed)
- ✅ Device type and OS
- ✅ Browser information
- ✅ Screen resolution
- ✅ Timezone

## Troubleshooting

- **Can't access from outside**: Check firewall, use ngrok, or deploy to cloud
- **No geolocation**: IP-based geolocation will still work (city-level accuracy)
- **Port blocked**: Change port in `server.py` (line with `port=5000`)

## Legal Notice

⚠️ Only use this for authorized security testing and competitions. Ensure you have permission before testing.

