# 使用轻量级的 Debian 基础镜像
FROM debian:stable-slim

# 设置工作目录
WORKDIR /app

# 安装必要的工具：bash 和 curl
# curl 用于网络请求，bash 是运行脚本的环境
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    curl \
    # 清理APT缓存，减小镜像体积
    && rm -rf /var/lib/apt/lists/*

# 复制脚本和启动脚本到镜像中
COPY cfmonitor.sh /usr/local/bin/cfmonitor.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# 赋予执行权限
RUN chmod +x /usr/local/bin/cfmonitor.sh /usr/local/bin/entrypoint.sh

# 设置容器启动时执行的入口点
# entrypoint.sh 将负责设置环境并启动监控服务
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# 默认命令（由 entrypoint.sh 实际调用）
CMD ["run"]
