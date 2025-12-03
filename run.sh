#!/bin/bash

# goscon启动脚本
# 用于在前台启动goscon服务，显示日志输出

# 检查goscon可执行文件是否存在
if [ ! -f "./goscon" ]; then
    echo "错误: 找不到goscon可执行文件，请先编译项目"
    echo "运行命令: go build -mod=vendor"
    exit 1
fi

# 检查配置文件是否存在
if [ ! -f "./config.yaml" ]; then
    echo "错误: 找不到config.yaml配置文件"
    exit 1
fi

# 创建日志目录
mkdir -p logs

echo "启动goscon服务..."
echo "配置文件: config.yaml"
echo "日志级别: 10 (详细)"
echo "日志输出: 控制台"
echo "按Ctrl+C停止服务"
echo "----------------------------------------"

# 启动goscon服务
./goscon -logtostderr -v 10 -config config.yaml