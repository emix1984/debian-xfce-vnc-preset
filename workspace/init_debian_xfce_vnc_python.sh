#!/bin/bash
# docker镜像要求：consol/debian-xfce-vnc:v2.0.3
# 作者：Emix1984
# 日期：2026/03/23
# 优化版：增加了错误控制、路径容错和环境检测优化

# 遇错即止，确保任何一步失败都不会继续执行
set -e

# 全局变量，用于存储安装选择
INSTALL_CHROMIUM="n"
INSTALL_DESKTOP="n"

# 交互式选择菜单
function show_interactive_menu() {
    echo "=========================================="
    echo "      Debian XFCE VNC 环境配置助手        "
    echo "=========================================="
    
    # 选项 1: Chromium
    read -p "1. 是否安装 Chromium 及其驱动？ (y/N): " choice1
    [[ "$choice1" == "y" || "$choice1" == "Y" ]] && INSTALL_CHROMIUM="y" || INSTALL_CHROMIUM="n"

    # 选项 2: 桌面常用工具
    read -p "2. 是否安装桌面增强工具 (SQLiteBrowser/Geany/Tmux等)？ (y/N): " choice2
    [[ "$choice2" == "y" || "$choice2" == "Y" ]] && INSTALL_DESKTOP="y" || INSTALL_DESKTOP="n"

    # 打印预览清单
    echo -e "\n--- [ 配置预览清单 ] ---"
    echo "• 必选核心开发环境:   [ 已选 ]"
    echo "• Chromium 浏览器驱动: [ $( [[ "$INSTALL_CHROMIUM" == "y" ]] && echo "是 [安装]" || echo "否 [跳过]" ) ]"
    echo "• 桌面图形增强工具:   [ $( [[ "$INSTALL_DESKTOP" == "y" ]] && echo "是 [安装]" || echo "否 [跳过]" ) ]"
    echo "------------------------"
    
    read -p "确认以上配置并开始执行？ (Y/n): " confirm
    if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        echo "已取消。请重新运行脚本并重新选择。"
        exit 0
    fi
    echo -e ">>> 配置确认成功，准备启动部署流程...\n"
}

# 定义功能函数
function update_system_packages() {
    echo ">>> 1. 更新系统包管理清单"
    apt-get update
}

function install_common_packages() {
    echo ">>> 2a. 安装核心基础开发工具 (Git, Curl, Unzip等)"
    # 核心包：体积小，开发必备
    DEBIAN_FRONTEND=noninteractive apt-get install -y git curl wget unzip ca-certificates net-tools

    if [[ "$INSTALL_DESKTOP" == "y" ]]; then
        echo ">>> 2b. 安装桌面图形增强与辅助工具 (SQLiteBrowser, Geany, Screen等)"
        DEBIAN_FRONTEND=noninteractive apt-get install -y sqlitebrowser geany gdebi nano tree tmux screen
    else
        echo ">>> 跳过桌面增强工具安装。"
    fi
}

function install_python_dev_packages() {
    echo ">>> 3. 安装Python开发包及必备编译环境"
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential zlib1g-dev libssl-dev libsqlite3-dev \
        python3 python3-dev python3-pip python3-venv
    
    # 自动升级 pip 到最新版本
    echo ">>> 正在升级 Python pip..."
    python3 -m pip install --upgrade pip
}

function install_chromium_driver_and_desktop_packages() {
    if [[ "$INSTALL_CHROMIUM" == "y" ]]; then
        echo ">>> Option. 安装 Chromium 系列浏览器及驱动"
        DEBIAN_FRONTEND=noninteractive apt-get install -y chromium chromium-driver
        echo "提示：容器内运行 Chromium 建议带上 --no-sandbox 参数。"
    else
        echo ">>> 跳过 Chromium 安装步骤。"
    fi
}

function check_python_dev_environment() {
    echo ">>> 4. 检查Python开发环境是否正常"
    
    if command -v python3 >/dev/null 2>&1; then
        echo "Python 3: $(python3 --version)"
    else
        echo "错误: Python 3 未正确安装！"
        exit 1
    fi

    if command -v pip3 >/dev/null 2>&1; then
        echo "Pip 3: $(pip3 --version)"
    else
        echo "错误: Pip3 未正确安装！"
        exit 1
    fi

    echo "Python开发环境检查通过。"
}

function clean_system() {
    echo ">>> 5. 清理缓存和临时文件..."
    apt-get autoremove -y
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    rm -rf /var/cache/apt/archives/*
    rm -rf /tmp/*
}

# 主执行流程
# 判断是否进入交互模式
if [[ -z "$1" && -z "$2" ]]; then
    show_interactive_menu
else
    # 静默模式：直接使用参数赋值
    INSTALL_CHROMIUM="$1"
    INSTALL_DESKTOP="$2"
fi

update_system_packages
install_common_packages
install_python_dev_packages
install_chromium_driver_and_desktop_packages
clean_system
check_python_dev_environment

echo "=========================================="
echo "   >>> 脚本执行完毕 <<<   "
echo "=========================================="
