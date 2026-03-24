FROM alpine:latest

# Install dependencies
RUN apk add --no-cache ca-certificates curl unzip

# Download Xray
RUN curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip && \
    unzip xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm xray.zip

# Create config directory
RUN mkdir -p /etc/xray

# Copy config
COPY config.json /etc/xray/config.json
COPY config.json /etc/xray/railway.json

# Expose port
EXPOSE 8080

# Run Xray
CMD ["/usr/local/bin/xray", "-c", "/etc/xray/config.json"]
