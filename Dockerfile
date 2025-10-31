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

# 2. 设置工作目录为 appuser 的主目录
# 容器内的 HOME 变量将指向 /home/appuser
WORKDIR /home/appuser

# 3. 复制文件并设置所有权给 appuser
COPY cfmonitor.sh /usr/local/bin/cfmonitor.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown appuser:appgroup /usr/local/bin/cfmonitor.sh /usr/local/bin/entrypoint.sh

# 4. 赋予执行权限
RUN chmod +x /usr/local/bin/cfmonitor.sh /usr/local/bin/entrypoint.sh

# 5. 切换到非特权用户运行，解决权限问题
USER appuser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["run"]
