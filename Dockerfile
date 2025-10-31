FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/<你的GitHub用户名>/cf-vps-monitor"
LABEL maintainer="<你的名字或邮箱>"

# 安装依赖
RUN apt-get update && apt-get install -y curl jq procps net-tools iproute2 bc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 复制脚本
WORKDIR /app
COPY cfmonitor.sh /app/cfmonitor.sh
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/*.sh

# 运行入口
ENTRYPOINT ["/app/entrypoint.sh"]
