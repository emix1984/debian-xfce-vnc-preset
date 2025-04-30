#!/bin/bash

# 定义函数：安装必要的编译依赖
install_dependencies() {
    echo "正在安装必要的编译依赖..."
    apt update
    apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget
}

# 定义函数：安装 Python 3 及相关软件包
install_python3() {
    echo "正在安装 Python 3 及相关软件包..."
    apt install -y python3 python3-pip python3-venv
}

# 定义函数：创建虚拟环境并安装依赖
setup_venv_and_install_requirements() {
    echo "正在创建虚拟环境..."
    python3 -m venv ./venv

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

# 检查是否已安装 Python 3
if command -v python3 &> /dev/null; then
    echo "Python 3 已安装。"
    echo "Python 3 的路径为：$(which python3)"
else
    echo "Python 3 未安装，正在安装必要依赖和 Python 3..."
    install_dependencies
    install_python3
fi

# 创建虚拟环境并安装 requirements.txt 中的库
setup_venv_and_install_requirements

# 提示用户
echo "虚拟环境已创建并激活。"
echo "当前目录下的 requirements.txt 文件中的库已安装。"
