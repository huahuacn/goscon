#!/bin/bash

# goscon停止脚本
# 用于停止正在运行的goscon服务

echo "正在查找goscon进程..."

# 首先尝试从PID文件获取进程ID
if [ -f "goscon.pid" ]; then
    PID=$(cat goscon.pid)
    echo "从PID文件获取到goscon进程ID: $PID"
    
    # 检查进程是否仍在运行
    if ps -p $PID > /dev/null 2>&1; then
        echo "找到goscon进程，PID: $PID"
    else
        echo "PID文件中的进程($PID)已不存在，将查找所有goscon进程"
        PID=""
    fi
fi

# 如果PID文件不存在或进程已不存在，则查找所有goscon进程
if [ -z "$PID" ]; then
    PID=$(ps aux | grep "[g]oscon" | awk '{print $2}')
fi

if [ -z "$PID" ]; then
    echo "没有找到正在运行的goscon进程"
    exit 1
fi

echo "找到goscon进程，PID: $PID"
echo "正在停止goscon服务..."

# 尝试优雅地停止进程
kill $PID

# 等待进程结束
sleep 2

# 检查进程是否还在运行
if ps -p $PID > /dev/null 2>&1; then
    echo "进程仍在运行，强制终止..."
    kill -9 $PID
    sleep 1
fi

# 再次检查
if ps -p $PID > /dev/null 2>&1; then
    echo "错误: 无法停止goscon进程"
    exit 1
else
    echo "goscon服务已成功停止"
    # 删除PID文件
    if [ -f "goscon.pid" ]; then
        rm -f goscon.pid
    fi
fi