#!/bin/sh

# Start Xray
echo "Starting Xray..."
/usr/local/bin/xray -c /etc/xray/config.json &

# Update Cloudflare DNS if token is set
if [ -n "$CF_TOKEN" ] && [ -n "$CF_ZONE_ID" ] && [ -n "$CF_DOMAIN" ]; then
    echo "Updating Cloudflare DNS..."
    
    # Get public IP
    PUBLIC_IP=$(curl -s https://api.ipify.org)
    
    if [ -n "$PUBLIC_IP" ]; then
        # Get DNS record ID
        RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?type=A&name=${CF_DOMAIN}" \
            -H "Authorization: Bearer ${CF_TOKEN}" \
            -H "Content-Type: application/json" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        
        if [ -n "$RECORD_ID" ]; then
            curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${RECORD_ID}" \
                -H "Authorization: Bearer ${CF_TOKEN}" \
                -H "Content-Type: application/json" \
                --data "{\"type\":\"A\",\"name\":\"${CF_DOMAIN}\",\"content\":\"${PUBLIC_IP}\",\"ttl\":120,\"proxied\":false}"
            echo "✓ DNS updated: ${CF_DOMAIN} -> ${PUBLIC_IP}"
        else
            echo "✗ DNS record not found for ${CF_DOMAIN}"
        fi
    fi
fi

wait
