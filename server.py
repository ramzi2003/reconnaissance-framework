#!/usr/bin/env python3
"""
Information Collection Server
Collects IP, geolocation, and system info from visitors
"""

from flask import Flask, request, jsonify, send_from_directory
import json
import datetime
from ipaddress import ip_address
import requests

app = Flask(__name__)

# Store collected data
collected_data = []

def get_client_ip():
    """Extract real client IP from request"""
    if request.headers.get('X-Forwarded-For'):
        ip = request.headers.get('X-Forwarded-For').split(',')[0].strip()
    elif request.headers.get('X-Real-IP'):
        ip = request.headers.get('X-Real-IP')
    else:
        ip = request.remote_addr
    return ip

def get_ip_geolocation(ip):
    """Get geolocation from IP using free API"""
    try:
        # Using ip-api.com (free, no key required)
        response = requests.get(f'http://ip-api.com/json/{ip}', timeout=5)
        if response.status_code == 200:
            geo_data = response.json()
            if geo_data.get('status') == 'success':
                return {
                    'country': geo_data.get('country'),
                    'region': geo_data.get('regionName'),
                    'city': geo_data.get('city'),
                    'zip': geo_data.get('zip'),
                    'lat': geo_data.get('lat'),
                    'lon': geo_data.get('lon'),
                    'timezone': geo_data.get('timezone'),
                    'isp': geo_data.get('isp'),
                    'org': geo_data.get('org'),
                    'as': geo_data.get('as'),
                }
    except Exception as e:
        print(f"Geolocation API error: {e}")
    return None

@app.route('/')
def index():
    """Serve the collection page"""
    return send_from_directory('.', 'index.html')

@app.route('/collect', methods=['POST'])
def collect():
    """Collect information from client"""
    try:
        client_ip = get_client_ip()
        
        # Get client data from request
        client_data = request.get_json() or {}
        
        # Collect server-side information
        server_data = {
            'timestamp': datetime.datetime.now().isoformat(),
            'ip_address': client_ip,
            'user_agent': request.headers.get('User-Agent'),
            'referer': request.headers.get('Referer'),
            'accept_language': request.headers.get('Accept-Language'),
            'accept_encoding': request.headers.get('Accept-Encoding'),
            'connection': request.headers.get('Connection'),
            'host': request.headers.get('Host'),
            'all_headers': dict(request.headers),
        }
        
        # Get IP-based geolocation (fallback if browser geolocation fails)
        ip_geo = get_ip_geolocation(client_ip)
        if ip_geo:
            server_data['ip_geolocation'] = ip_geo
        
        # Merge client and server data
        full_data = {
            **client_data,
            **server_data
        }
        
        # Store the data
        collected_data.append(full_data)
        
        # Also print to console for immediate viewing
        print("\n" + "="*80)
        print("NEW DATA COLLECTED:")
        print("="*80)
        print(json.dumps(full_data, indent=2))
        print("="*80 + "\n")
        
        # Save to file (use absolute path for systemd)
        import os
        data_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'collected_data.json')
        with open(data_file, 'a') as f:
            f.write(json.dumps(full_data, indent=2) + '\n\n')
        
        return jsonify({
            'status': 'success',
            'message': 'Data collected successfully'
        })
        
    except Exception as e:
        print(f"Error collecting data: {e}")
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500

@app.route('/view', methods=['GET'])
def view():
    """View all collected data (for you to check)"""
    return jsonify({
        'total_collections': len(collected_data),
        'data': collected_data
    })

@app.route('/clear', methods=['POST'])
def clear():
    """Clear collected data"""
    global collected_data
    collected_data = []
    return jsonify({'status': 'cleared'})

if __name__ == '__main__':
    import os
    
    # Production settings
    debug_mode = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    
    print("\n" + "="*80)
    print("INFORMATION COLLECTION SERVER STARTED")
    print("="*80)
    print(f"\nServer running on: http://0.0.0.0:5000")
    print(f"Debug mode: {debug_mode}")
    print(f"\nTo view collected data: http://YOUR_IP/view")
    print("="*80 + "\n")
    
    # Use production WSGI server in production
    if not debug_mode:
        try:
            from waitress import serve
            print("Using Waitress production server...")
            serve(app, host='0.0.0.0', port=5000)
        except ImportError:
            print("Waitress not installed, using Flask dev server (not recommended for production)")
            app.run(host='0.0.0.0', port=5000, debug=False)
    else:
        app.run(host='0.0.0.0', port=5000, debug=True)

