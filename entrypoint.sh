#!/bin/bash
set -e

echo "启动 cf-vps-monitor 容器..."
echo "加载环境变量..."

# 检查必要变量
: "${API_KEY:?请设置 API_KEY 环境变量}"
: "${MONITOR_INTERVAL:=300}"

echo "监控间隔: $MONITOR_INTERVAL 秒"
echo "开始执行主程序..."
exec /app/cfmonitor.sh
