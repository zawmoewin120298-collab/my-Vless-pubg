#!/bin/bash

# Function to update Cloudflare DNS
update_cloudflare_dns() {
    echo "Updating Cloudflare DNS..."
    
    # Get public IP
    PUBLIC_IP=$(curl -s https://api.ipify.org)
    
    # Update DNS record
    curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_DNS_RECORD_ID}" \
        -H "Authorization: Bearer ${CF_TOKEN}" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"${CF_DOMAIN}\",\"content\":\"${PUBLIC_IP}\",\"ttl\":120,\"proxied\":false}"
}

# Get DNS record ID first (run once, save to Railway variable)
if [ -z "$CF_DNS_RECORD_ID" ]; then
    echo "Getting DNS record ID..."
    RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records?type=A&name=${CF_DOMAIN}" \
        -H "Authorization: Bearer ${CF_TOKEN}" \
        -H "Content-Type: application/json" | jq -r '.result[0].id')
    
    if [ "$RECORD_ID" != "null" ] && [ -n "$RECORD_ID" ]; then
        echo "CF_DNS_RECORD_ID=$RECORD_ID"
        export CF_DNS_RECORD_ID=$RECORD_ID
    fi
fi

# Start Xray
echo "Starting Xray with GRPC..."
exec /usr/local/bin/xray -c /etc/xray/config.json
