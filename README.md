# NoVNC-DebianXfce
dockerhub: consol/debian-xfce-vnc:v2.0.3

# 部署并启动容器项目
## NoVNC-DebianXfce - workspace 

```bash
apt update && apt install -y curl && \
curl -fsSL -o deploy_novnc_workspace.sh https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/deploy_novnc_workspace.sh && \
chmod +x deploy_novnc_workspace.sh && \
bash deploy_novnc_workspace.sh
```

# DebianXfce系统环境初始化
## NoVNC-DebianXfce used for python-dev with chromium_dirver
```bash
apt update && apt install -y curl && \
curl -fsSL -o Setup_DebianXfceVNC_PythonDev.sh https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/Setup_DebianXfceVNC_PythonDev.sh && \
chmod +x Setup_DebianXfceVNC_PythonDev.sh && \
bash Setup_DebianXfceVNC_PythonDev.sh y
```

## NoVNC-DebianXfce used for python-dev without chromium_dirver
```bash
apt update && apt install -y curl && \
curl -fsSL -o Setup_DebianXfceVNC_PythonDev.sh https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/Setup_DebianXfceVNC_PythonDev.sh && \
chmod +x Setup_DebianXfceVNC_PythonDev.sh && \
bash Setup_DebianXfceVNC_PythonDev.sh
```

# Python项目开发环境初始化
## PythonProject_init
```bash
apt update && apt install -y curl && \
curl -fsSL -o PythonProject_init.sh https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/PythonProject_init.sh && \
chmod +x PythonProject_init.sh && \
bash PythonProject_init.sh
```

# 使用方法：
1. 克隆项目到本地文件夹名称为nv_test
```bash
git clone https://github.com/emix1984/debian-xfce-vnc-preset.git nv_test
cd nv_test
```

2. 启动开发环境
```bash
docker-compose -f docker-compose.dev.yml up -d
```

```bash
docker-compose -f docker-compose.dev.yml down
```
