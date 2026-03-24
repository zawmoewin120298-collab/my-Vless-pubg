#!/bin/bash

# Xray ကို background မှာ အရင် run မယ်
xray run -c /etc/xray/config.json &

# Cloudflare Token ရှိရင် Cloudflare ကို run မယ်
if [ ! -z "$TUNNEL_TOKEN" ]; then
    echo "Starting Cloudflare Tunnel..."
    cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN
# Ngrok Token ရှိရင် Ngrok ကို run မယ်
elif [ ! -z "$NGROK_AUTHTOKEN" ]; then
    echo "Starting Ngrok Tunnel..."
    ngrok tcp 443 --authtoken $NGROK_AUTHTOKEN
else
    echo "Error: No Token provided (TUNNEL_TOKEN or NGROK_AUTHTOKEN)"
    exit 1
fi
