#!/bin/bash
set -e

echo "===== 启动 cf-vps-monitor 容器 ====="
echo "加载环境变量..."
echo "API_KEY: ${API_KEY:0:6}..."
echo "SERVER_ID: $SERVER_ID"
echo "WORKER_URL: $WORKER_URL"
echo "--------------------------------------------"

# 执行安装脚本（自动检测是否已配置）
exec /app/cfmonitor.sh -i -k "${API_KEY}" -s "${SERVER_ID}" -u "${WORKER_URL}"

echo "--------------------------------------------"
echo "安装脚本执行完毕，启动日志守护模式..."
LOG_FILE="/app/.cf-vps-monitor/logs/monitor.log"

# 若日志文件不存在则等待创建
if [ ! -f "$LOG_FILE" ]; then
  echo "等待日志文件创建..."
  mkdir -p "$(dirname "$LOG_FILE")"
  touch "$LOG_FILE"
fi

# 持续输出日志，防止容器退出
echo "正在持续监控日志输出..."
tail -F "$LOG_FILE"
