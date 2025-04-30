#!/bin/bash

# 定义函数：安装必要的编译依赖
install_dependencies() {
    echo "正在安装必要的编译依赖..."
    sudo apt update
    sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget
}

# 定义函数：安装 Python 3.10
install_python310() {
    echo "正在安装 Python 3.10..."
    sudo apt install -y python3.10 python3.10-venv python3.10-pip
}

# 定义函数：更新 pip 到最新版本
update_pip() {
    echo "正在更新 pip 到最新版本..."
    python3.10 -m pip install --upgrade pip
}

# 定义函数：创建虚拟环境并安装依赖
setup_venv_and_install_requirements() {
    echo "正在创建虚拟环境..."
    python3.10 -m venv ./venv

    echo "正在激活虚拟环境..."
    source ./venv/bin/activate

    echo "正在更新虚拟环境中的 pip 到最新版本..."
    pip install --upgrade pip

    if [ -f requirements.txt ]; then
        echo "正在安装 requirements.txt 中的库..."
        pip install -r requirements.txt
    else
        echo "当前目录下未找到 requirements.txt 文件。"
    fi
}

# 主程序
echo "开始设置 Python 环境..."

# 检查是否已安装 Python 3.10
if ! command -v python3.10 &> /dev/null; then
    echo "Python 3.10 未安装，正在安装必要依赖和 Python 3.10..."
    install_dependencies
    install_python310
else
    echo "Python 3.10 已安装。"
fi

# 更新系统中的 pip 到最新版本
update_pip

# 创建虚拟环境并安装 requirements.txt 中的库
setup_venv_and_install_requirements

# 提示用户
echo "虚拟环境已创建并激活。"
echo "当前目录下的 requirements.txt 文件中的库已安装。"
