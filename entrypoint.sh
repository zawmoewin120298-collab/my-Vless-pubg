#!/bin/sh

# Start Xray in background
echo "Starting Xray..."
/usr/local/bin/xray -c /etc/xray/config.json &

# Start Cloudflare Tunnel if token exists
if [ -n "$TUNNEL_TOKEN" ]; then
    echo "Starting Cloudflare Tunnel..."
    /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &
else
    echo "No tunnel token found, skipping Cloudflare Tunnel"
fi

# Wait for all background processes
wait
