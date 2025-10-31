FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/<你的用户名>/cf-vps-monitor"

RUN apt-get update && apt-get install -y curl jq procps net-tools iproute2 bc dos2unix && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY cfmonitor.sh /app/cfmonitor.sh
COPY entrypoint.sh /app/entrypoint.sh

# 修正权限和换行符问题
RUN dos2unix /app/*.sh && chmod +x /app/*.sh

ENTRYPOINT ["/app/entrypoint.sh"]

