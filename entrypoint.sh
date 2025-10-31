#!/bin/bash
set -eo pipefail

# 环境变量设置和目录定义（与 cfmonitor.sh 保持一致，假设容器用户为 root 或 $HOME 为 /root）
SCRIPT_DIR="/root/.cf-vps-monitor"
CONFIG_FILE="$SCRIPT_DIR/config/config"
BIN_DIR="$SCRIPT_DIR/bin"
SERVICE_FILE="$BIN_DIR/vps-monitor-service.sh"

# 1. 确保必要的目录结构存在
echo "Setting up necessary directories..."
mkdir -p "$SCRIPT_DIR/config" "$BIN_DIR"

# 2. 根据容器环境变量写入配置
# 使用用户设置的环境变量（或默认值）来生成 cfmonitor.sh 预期的配置文件。
# 对应 cfmonitor.sh 中的 DEFAULT_* 变量
echo "Writing configuration from environment variables..."
echo "WORKER_URL=\"${WORKER_URL:-https://default.worker.url/}\"" > "$CONFIG_FILE"
echo "SERVER_ID=\"${SERVER_ID:-default_server_id}\"" >> "$CONFIG_FILE"
echo "API_KEY=\"${API_KEY:-default_api_key}\"" >> "$CONFIG_FILE"
echo "INTERVAL=\"${INTERVAL:-10}\"" >> "$CONFIG_FILE"
echo "Configuration written to $CONFIG_FILE"

# 3. 创建监控服务脚本 (vps-monitor-service.sh)
# 由于原始服务脚本缺失，这里提供一个使用 $CONFIG_FILE 配置的监控循环的示例。
cat << 'EOF' > "$SERVICE_FILE"
#!/bin/bash
# 加载配置
. "$CONFIG_FILE"
# 核心监控循环：每隔 $INTERVAL 秒执行一次 cfmonitor.sh 的核心功能（此处假设为 'test' 或 'monitor'）
echo "Starting monitoring loop every ${INTERVAL} seconds..."
while true; do
    # 假设 'test' 命令包含了发送数据给 Worker 的核心逻辑。
    /usr/local/bin/cfmonitor.sh test 
    sleep "$INTERVAL"
done
EOF

chmod +x "$SERVICE_FILE"
echo "Service script created at $SERVICE_FILE"


# 4. 启动 cfmonitor 服务
# 运行 cfmonitor.sh 的 start 命令，它会启动上面创建的 $SERVICE_FILE 脚本。
echo "Starting cf-vps-monitor service..."
/usr/local/bin/cfmonitor.sh start

# 5. 保持容器在前台运行
# 由于 start 命令可能会后台运行服务，我们通过 tail -f /dev/null 来防止容器立即退出。
echo "cf-vps-monitor started. Keeping container alive in foreground."
exec tail -f /dev/null
