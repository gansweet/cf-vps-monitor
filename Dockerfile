# 使用轻量级的 Debian 基础镜像
FROM debian:stable-slim

# 安装必要的工具：bash 和 curl
# curl 用于网络请求，bash 是运行脚本的环境
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    curl \
    # 清理APT缓存，减小镜像体积
    && rm -rf /var/lib/apt/lists/*

# 1. 创建一个新的非特权用户和用户组
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# 2. 创建主工作目录 /app
RUN mkdir -p /app 

# 3. 设置 /app 的所有权给 appuser
# 这是关键，确保非特权用户 appuser 对 /app 有完全的写入和创建子目录的权限
RUN chown -R appuser:appgroup /app

# 4. 设置工作目录为 /app
WORKDIR /app
EXPOSE 7860 80 443 8080 8443 2053 2083 2087 2096 3000
# 5. 复制文件并设置权限
COPY cfmonitor.sh /usr/local/bin/cfmonitor.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# entrypoint.sh 和 cfmonitor.sh 需要 root 才能复制到 /usr/local/bin，但要确保它们可被 appuser 执行
RUN chown root:root /usr/local/bin/cfmonitor.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/cfmonitor.sh /usr/local/bin/entrypoint.sh

# 6. 切换到非特权用户运行
USER appuser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["run"]



