FROM alpine:latest

# Install dependencies (jq မပါတော့ဘူး)
RUN apk add --no-cache ca-certificates curl unzip

# Download and install Xray
RUN curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip

# Create directories
RUN mkdir -p /etc/xray

# Copy config and entrypoint
COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
