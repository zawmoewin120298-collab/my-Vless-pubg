FROM alpine:latest

# လိုအပ်တဲ့ Tools များသွင်းခြင်း
RUN apk add --no-cache wget unzip ca-certificates bash curl

# 1. Xray-core သွင်းခြင်း
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# 2. Cloudflared သွင်းခြင်း
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# 3. Ngrok သွင်းခြင်း
RUN curl -s https://bin.equinox.io/c/bNy73dqVs7w/ngrok-v3-stable-linux-amd64.tgz | tar xz -C /usr/local/bin

WORKDIR /etc/xray
COPY config.json .

# Entrypoint script ကိုသုံးပြီး process များကို စီမံခြင်း
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
