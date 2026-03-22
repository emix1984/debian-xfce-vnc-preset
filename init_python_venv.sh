#!/bin/bash
# 项目名称：Python 项目初始化脚本
# 描述：用于在指定项目目录中创建并配置虚拟环境，并安装依赖。
# 作者：Emix1984
# 日期：2026/03/23

set -e

# 模块：检查并安装系统级依赖
function check_and_install_system_deps() {
    echo ">>> 1. 检查并补全系统级 Python 开发依赖..."
    
    local REQUIRED_PACKAGES=("python3" "python3-dev" "python3-pip" "python3-venv" "build-essential")
    local MISSING_PACKAGES=()

    # 过滤出缺失的包
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            MISSING_PACKAGES+=("$pkg")
        fi
    done

    # 如果有缺失，执行安装
    if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
        echo "提示: 检测到以下系统依赖缺失: ${MISSING_PACKAGES[*]}"
        echo "正在执行自动安装 (需要 root 权限)..."
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y "${MISSING_PACKAGES[@]}"
    else
        echo ">>> 系统基础依赖已就绪。"
    fi
}

function init_python_project() {
    echo "=========================================="
    echo "   >>> 开始初始化 Python 项目环境 <<<   "
    echo "=========================================="
    
    # 获取脚本所在目录作为项目根目录
    local PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local REQ_FILE="${PROJECT_DIR}/requirements.txt"
    local VENV_DIR="${PROJECT_DIR}/venv"

    # 检查 requirements.txt 是否存在
    if [ ! -f "$REQ_FILE" ]; then
        echo "提示: 在目录 ${PROJECT_DIR} 下未找到 requirements.txt。"
        echo "你可以手动创建该文件并再次运行此脚本，或者直接手动安装依赖。"
        return 0
    fi

    # 创建或更新虚拟环境
    if [ -d "$VENV_DIR" ]; then
        echo ">>> 虚拟环境 venv 已存在，将进行增量更新。"
    else
        echo ">>> 正在创建虚拟环境 (venv)..."
        python3 -m venv "$VENV_DIR"
    fi

    # 激活虚拟环境
    echo ">>> 激活虚拟环境并安装依赖..."
    source "${VENV_DIR}/bin/activate"

    # 升级 pip 并安装依赖
    pip3 install --upgrade pip
    pip3 install -r "$REQ_FILE"

    # 统计虚拟环境内已安装的包数量
    local PKG_COUNT=$(pip list | tail -n +3 | wc -l)
    deactivate

    echo "=========================================="
    echo "   >>> Python 项目初始化完成！ <<<    "
    echo "=========================================="
    echo "项目详情 (Project Summary):"
    echo "- 当前工作目录: $(pwd)"
    echo "- 解释器版本:   $(${VENV_DIR}/bin/python3 --version)"
    echo "- Pip 版本:      $(${VENV_DIR}/bin/pip3 --version | awk '{print $1,$2}')"
    echo "- 已装依赖包:   ${PKG_COUNT} 个软件包"
    echo "------------------------------------------"
    echo "使用提示 (Quick Guide):"
    echo "1. 激活环境: source venv/bin/activate"
    echo "2. 退出环境: deactivate"
    echo "3. 运行代码: python3 your_script.py"
    echo "=========================================="
}

# 主执行流程
# 1. 首先检查并安装系统级依赖
check_and_install_system_deps

# 2. 然后初始化 Python 项目环境 (venv + 依赖)
init_python_project
