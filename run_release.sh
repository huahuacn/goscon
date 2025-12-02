#!/bin/bash

# goscon发布版本启动脚本
# 用于在后台静默运行goscon服务，日志写入文件

# 检查goscon可执行文件是否存在
if [ ! -f "./goscon" ]; then
    echo "错误: 找不到goscon可执行文件，请先编译项目"
    echo "运行命令: go build -ldflags \"-w -s\" -mod=vendor"
    exit 1
fi

# 检查配置文件是否存在
if [ ! -f "./config.yaml" ]; then
    echo "错误: 找不到config.yaml配置文件"
    exit 1
fi

# 创建日志目录
mkdir -p logs

# 检查是否已经有goscon进程在运行
PID=$(ps aux | grep "[g]oscon" | awk '{print $2}')
if [ ! -z "$PID" ]; then
    echo "goscon服务已在运行，PID: $PID"
    echo "如需重启，请先运行: ./stop.sh"
    exit 1
fi

echo "启动goscon服务(后台模式)..."
echo "配置文件: config.yaml"
echo "日志级别: 1 (基本)"
echo "日志输出: 文件 (logs/goscon.log)"
echo "----------------------------------------"

# 后台启动goscon服务，不输出到控制台，日志写入文件
nohup ./goscon -v 1 -config config.yaml > logs/goscon.log 2>&1 &

# 获取新启动进程的PID
PID=$!
echo $PID > goscon.pid

echo "goscon服务已启动，PID: $PID"
echo "日志文件: logs/goscon.log"
echo "进程ID文件: goscon.pid"
echo "使用 './stop.sh' 停止服务"
echo "使用 'tail -f logs/goscon.log' 查看日志"