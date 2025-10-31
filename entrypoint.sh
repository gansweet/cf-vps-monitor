#!/bin/bash
set -e

echo "===== Application Startup at $(date '+%Y-%m-%d %H:%M:%S') ====="
echo "启动 cf-vps-monitor 容器..."
echo "加载环境变量..."

: "${API_KEY:?请设置 API_KEY 环境变量}"
: "${SERVER_ID:?请设置 SERVER_ID 环境变量}"
: "${WORKER_URL:?请设置 WORKER_URL 环境变量}"
: "${$INTERVAL:=300}"

echo "监控间隔: $INTERVAL 秒"
echo "执行命令: /app/cfmonitor.sh -i -k ${API_KEY} -s ${SERVER_ID} -u ${WORKER_URL}"
echo "--------------------------------------------"

# 确保主脚本存在且可执行
if [ ! -x /app/cfmonitor.sh ]; then
  echo "错误: /app/cfmonitor.sh 不存在或不可执行。"
  ls -l /app/
  exit 1
fi

exec /app/cfmonitor.sh -i "${INTERVAL}" -k "${API_KEY}" -s "${SERVER_ID}" -u "${WORKER_URL}"
# 保持前台运行（防止容器退出）
tail -f /dev/null
