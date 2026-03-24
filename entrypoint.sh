#!/bin/bash

echo "========================================="
echo "Starting Xray VLESS + Cloudflare Tunnel"
echo "========================================="

# Start Xray in background
echo "[*] Starting Xray on port 8080..."
/usr/local/bin/xray -c /etc/xray/config.json &

# Wait for Xray to start
sleep 2

# Start Cloudflare Tunnel if token exists
if [ -n "$TUNNEL_TOKEN" ]; then
    echo "[*] Cloudflare Tunnel token found, starting tunnel..."
    /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &
    echo "[✓] Cloudflare Tunnel started"
else
    echo "[!] No TUNNEL_TOKEN found, running without tunnel"
    echo "[!] Use Railway domain: my-vless-pubg-production.up.railway.app:8080"
fi

echo "========================================="
echo "[✓] Services started successfully"
echo "========================================="

# Keep container running
wait
