FROM alpine:latest

RUN apk add --no-cache wget unzip ca-certificates bash libc6-compat

# Xray core setup
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm Xray-linux-64.zip

# Cloudflared setup
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

WORKDIR /etc/xray
COPY config.json .

# Speed မြန်အောင် Tunnel protocol ကို http2 ပြောင်းထားပါတယ်
# Dockerfile ရဲ့ အောက်ဆုံးစာကြောင်းမှာ ဒါကို သုံးပေးပါ
CMD /usr/local/bin/xray run -c /etc/xray/config.json & /usr/local/bin/cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN

