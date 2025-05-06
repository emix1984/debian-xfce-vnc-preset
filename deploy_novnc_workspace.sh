#!/bin/bash

# 提示用户输入容器名称
read -p "请输入容器名称: " container_name

# 提示用户输入主机端口（NOVNC）
read -p "请输入主机端口 (NOVNC，默认9601): " host_port_novnc
host_port_novnc=${host_port_novnc:-9601}

# 提示用户输入主机端口（VNC），默认不映射
read -p "请输入主机端口 (VNC，直接回车跳过，默认不映射): " host_port_vnc

# 提示用户输入 VNC 密码，默认为1234
read -p "请输入 VNC 密码 (默认1234): " vnc_password
vnc_password=${vnc_password:-1234}

# 下载 docker-compose.yml 文件
curl -O http://your-network-location/docker-compose.yml

# 检查文件是否下载成功
if [ ! -f "docker-compose.yml" ]; then
  echo "错误：未能下载 docker-compose.yml 文件"
  exit 1
fi

# 替换文件中的容器名称
sed -i "s/novnc_debian:/${container_name}:/g" docker-compose.yml

# 替换文件中的端口映射（NOVNC）
sed -i "s/host_port_novnc:6901/${host_port_novnc}:6901/g" docker-compose.yml

# 如果用户输入了主机端口（VNC），则替换对应的占位符，否则保持默认不映射
if [ -n "$host_port_vnc" ]; then
  sed -i "s/host_port_vnc:5901/${host_port_vnc}:5901/g" docker-compose.yml
else
  sed -i "/host_port_vnc:5901/d" docker-compose.yml
fi

# 替换文件中的 VNC 密码
sed -i "s/password/${vnc_password}/g" docker-compose.yml

# 启动服务
docker-compose -f docker-compose.yml up -d

# 验证服务是否成功启动
docker-compose -f docker-compose.yml ps

# 提示用户服务已启动
echo "服务已启动，容器名称为: ${container_name}"
echo "NOVNC 端口映射为: ${host_port_novnc}:6901"
if [ -n "$host_port_vnc" ]; then
  echo "VNC 端口映射为: ${host_port_vnc}:5901"
else
  echo "VNC 端口未映射"
fi
echo "VNC 密码为: ${vnc_password}"
