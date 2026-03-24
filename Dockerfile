FROM alpine:latest

# Install dependencies
RUN apk add --no-cache ca-certificates curl bash jq

# Download and install Xray
RUN curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip && \
    unzip xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm xray.zip

# Create directories
RUN mkdir -p /etc/xray /var/log/xray

# Copy config
COPY config.json /etc/xray/config.json

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
