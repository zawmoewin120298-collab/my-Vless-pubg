FROM alpine:latest

RUN apk add --no-cache wget unzip ca-certificates bash

# Download Xray with geoip
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# Download geoip.dat and geosite.dat
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/geoip.dat -O /usr/local/bin/geoip.dat && \
    wget https://github.com/XTLS/Xray-core/releases/latest/download/geosite.dat -O /usr/local/bin/geosite.dat

RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

WORKDIR /etc/xray
COPY config.json .

CMD xray run -c /etc/xray/config.json & cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN
