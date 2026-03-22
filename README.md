# Debian XFCE VNC Python 开发环境

这是一个专为 Python 开发者设计的预设容器项目。基于 `consol/debian-xfce-vnc:v2.0.3` 镜像，提供了图形化的 VNC 桌面环境，并集成了高度模块化的开发工具初始化流程。

## 🚀 部署工作流 (Deployment Workflow)

请按照以下三个阶段完成从环境启动到项目运行的全过程：

### 阶段一：宿主机部署 (Host)
1.  **克隆项目**：
    ```bash
    git clone https://github.com/emix1984/debian-xfce-vnc-preset.git my-python-lab
    cd my-python-lab
    ```
2.  **配置环境** (可选)：
    根据需求修改 `.env` 中的端口 (`HOST_PORT_NOVNC`) 和 VNC 密码 (`VNC_PASSWORD`)。
3.  **启动容器**：
    ```bash
    docker compose up -d
    ```
    启动完成后，通过浏览器访问：`http://localhost:9601` (默认端口)。

### 阶段二：系统环境初始化 (Container - VNC Desktop)
进入容器桌面的终端，执行系统级增强：
1.  **切换至工作目录**：
    ```bash
    cd /headless/Desktop/workspace
    ```
2.  **运行交互式配置脚本**：
    ```bash
    bash init_debian_xfce_vnc_python.sh
    ```
    按需选择是否安装 Chromium 浏览器和桌面图形增强包（SQLiteBrowser, Geany, Tmux 等）。

### 阶段三：项目开发环境初始化 (Container - Project)
在你的 Python 项目根目录下执行（需备好 `requirements.txt`）：
```bash
bash init_python_venv.sh
```
该步骤会自动检测系统依赖、创建 `venv` 虚拟环境并安装所有依赖包。

---

## 📂 文件结构说明 (Project Layout)

项目根目录采用物理隔离设计，区分了**管理配置**与**项目源码**：

*   **根目录 (Root)**: 负责宿主机的容器生命周期管理。
    *   `.env` —— 核心配置。
    *   `docker-compose.yml` —— 编排文件。
*   **workspace/**: 负责容器内的生产与初始化。
    *   `init_debian_xfce_vnc_python.sh` —— **系统级初始化模块**。
    *   `init_python_venv.sh` —— **项目级初始化模块**。

## 🛠️ 技术特性

*   **隔离挂载 (Isolated Mounting)**：不再挂载整个项目目录。仅将宿主机的 `./workspace` 挂载至容器桌面，保护宿主机隐私的同时隔离了编排文件。
*   **按需安装 (On-demand)**：通过交互式菜单，用户可以自由选择安装轻量版 (Core) 或全量版 (Full) 开发环境。
*   **自愈性 (Self-Healing)**：项目初始化脚本会自动检测并补足系统级核心运行时。

---

## 🔒 安全建议
*   建议在 `.env` 中修改默认的 VNC 密码。
*   容器默认以 `root` 用户运行以方便初始化，请根据生产环境安全策略评估使用。

---

## ⌨️ 进阶操作 (Advanced Operations)

### 如果需要停止或重启：
```bash
# 停止容器运行 (不删除)
docker compose stop
# 停止并移除容器 (清除资源)
docker compose down
# 强制重新创建容器 (当修改了 .env 或 compose 文件但没生效时)
docker compose up -d --force-recreate
# 如果将来你添加了自定义 Dockerfile，请使用此命令构建并启动
docker compose up -d --build
```

### 挂载说明：
宿主机的 `./workspace` 子目录会自动挂载到容器内的 `/headless/Desktop/workspace`。你可以直接在宿主机的 `workspace` 文件夹中编写代码，容器内会即时同步。

---

## ❓ 常见问题 (FAQ)

**Q: 运行 Chromium 浏览器报错或无法启动？**
A: 在 Docker 容器环境下，运行 Chromium 浏览器必须使用 `--no-sandbox` 标志。
- 命令行运行：`chromium --no-sandbox`
- 调试时请确保证环境已安装。

**Q: 必须运行两个脚本吗？**
A: **不需要**。
- 如果你只需要一个极致精简的 Python 运行环境（纯命令行），你可以直接运行 `bash init_python_venv.sh`。
- 如果你需要 VNC 桌面的图形辅助工具、编辑器或浏览器，请先运行 `bash init_debian_xfce_vnc_python.sh`。

**Q: 脚本升级 Pip 失败？**
A: 脚本会在安装 `python3-pip` 后尝试自动升级 Pip。如果遇到网络超时，可以手动检查 `python3 -m pip install --upgrade pip`。

---

## 🌍 远程调用模式 (Remote Execution Mode)

如果你已经在运行一个 `debian-xfce-vnc` 容器，且不想克隆整个项目，可以直接在容器终端内远程调用 GitHub 上的最新脚本：

### 1. 远程运行：系统环境初始化 (交互式)
```bash
curl -fsSL https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/workspace/init_debian_xfce_vnc_python.sh | bash
```

### 2. 远程运行：项目虚拟环境初始化 (基于当前目录)
```bash
curl -fsSL https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/workspace/init_python_venv.sh | bash
```
*(注意：远程调用模式下脚本将直接执行安装，建议在操作前确保已具备 root 权限。)*

---
*Powered by Emix1984*
