FROM alpine:latest

RUN apk add --no-cache curl unzip

RUN curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm /tmp/xray.zip

RUN mkdir -p /etc/xray

COPY config.json /etc/xray/config.json

EXPOSE 8080

CMD ["/usr/local/bin/xray", "-c", "/etc/xray/config.json"]
