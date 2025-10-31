FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y curl jq procps net-tools iproute2 bc dos2unix && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY cfmonitor.sh /app/cfmonitor.sh
COPY entrypoint.sh /app/entrypoint.sh

# 修正权限与换行符
RUN dos2unix /app/*.sh && chmod +x /app/*.sh && chmod -R 777 /app

ENTRYPOINT ["/app/entrypoint.sh"]

