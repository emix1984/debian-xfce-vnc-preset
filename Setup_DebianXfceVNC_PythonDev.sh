#!/bin/bash
# docker镜像要求：consol/debian-xfce-vnc:v2.0.3
# 作者：Emix1984
# 日期：2025/03/04

# 定义函数模块
function update_system_packages() {
    echo ">>> 1. 更新系统包管理清单"
    apt update || { echo "更新系统包失败！"; exit 1; }
}

function install_common_packages() {
    echo ">>> 2. 安装终端系统常用软件包"
    apt-get install -y git curl nano tree unzip net-tools screen gedit gdebi || { echo "安装常用软件包失败！"; exit 1; }
}

function install_python_dev_packages() {
    echo ">>> 3. 安装Python开发包"
    apt-get install -y openssl build-essential libssl-dev libffi-dev python3 python3-dev python3-pip python3-venv || { echo "安装Python开发包失败！"; exit 1; }
}

function install_chromium_driver_and_desktop_packages() {
    local choice="$1"  # 获取命令行参数
    case "$choice" in
        y|Y)
            echo ">>> Option. 安装chromium-driver开发包，系统桌面用软件包管理器，文本编辑器"
            apt-get install -y chromium chromium-driver || { echo "安装chromium-driver失败！"; exit 1; }
            ;;
        *)
            echo ">>> 跳过 Option. 安装chromium-driver开发包，继续执行后续步骤..."
            ;;
    esac
}

function init_python_project() {
    echo ">>> 初始化Python项目环境"
    # 检查requirements.txt是否存在
    if [ ! -f requirements.txt ]; then
        echo "requirements.txt 文件不存在，请确保该文件在当前目录下。"
        return 0  # 返回状态码0，表示成功跳过
    fi

    # 创建并激活虚拟环境
    python3 -m venv venv
    source venv/bin/activate

    # 升级pip并安装依赖
    pip3 install --upgrade pip
    pip3 install -r requirements.txt

    # 退出虚拟环境
    deactivate

    echo ">>> Python项目环境初始化完成，虚拟环境已退出。"
}

function check_python_dev_environment() {
    echo ">>> 检查Python开发环境是否正常"
    if ! python3 --version &>/dev/null; then
        echo "Python 3 未正确安装！"
        exit 1
    fi

    if ! pip3 --version &>/dev/null; then
        echo "pip3 未正确安装！"
        exit 1
    fi

    echo "Python开发环境检查通过。"
}

function clean_system() {
    echo "**** 清理缓存和临时文件 ****"
    # 清理不再需要的软件包
    apt autoremove -y
    # 清理APT缓存
    apt-get clean -y
    # 删除APT下载的包文件
    rm -rf /var/cache/apt/archives/*
    # 清理临时文件
    rm -rf /tmp/*
}

# 主执行流程
echo ">>> 配置Python开发环境 - 配置脚本开始执行"
update_system_packages
install_common_packages
install_python_dev_packages

# 根据命令行参数决定是否安装chromium-driver
install_chromium_driver_and_desktop_packages "$1"

# 初始化Python项目环境
init_python_project
# 在清理系统后立即检查环境
clean_system
check_python_dev_environment

echo ">>> 脚本执行完毕 <<<"
