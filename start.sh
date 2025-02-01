#!/bin/bash

# 更新系统软件包列表
apt update && apt install -y curl

# 下载并执行配置脚本
curl -fL -o Setup_DebianXfceVNC_PythonDev.sh https://github.com/emix1984/CustomizeServerEnvironment/raw/refs/heads/main/Setup_DebianXfceVNC_PythonDev.sh

# 给下载的脚本赋予可执行权限
chmod +x Setup_DebianXfceVNC_PythonDev.sh

# 执行下载的脚本，并传递参数 y
bash Setup_DebianXfceVNC_PythonDev.sh y

# 启动 VNC 服务
/dockerstartup/vnc_startup.sh --wait