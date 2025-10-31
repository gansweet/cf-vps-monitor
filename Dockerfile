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

# 2. 创建一个可供非特权用户写入的目录，并设置所有权
RUN mkdir -p /app/data && chown -R appuser:appgroup /app

# 3. 设置工作目录为 /app
WORKDIR /app

# 4. 复制文件并设置权限
COPY cfmonitor.sh /usr/local/bin/cfmonitor.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown appuser:appgroup /usr/local/bin/cfmonitor.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/cfmonitor.sh /usr/local/bin/entrypoint.sh

# 5. 切换到非特权用户运行
# 尽管 USER appuser，但我们在 entrypoint 中会使用绝对路径 /app/data
USER appuser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["run"]
