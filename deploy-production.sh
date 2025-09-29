#!/bin/bash

# FHEVM Wish Pool DApp - 生产部署脚本
# 使用方法: ./deploy-production.sh [start|stop|restart|status]

set -e

APP_NAME="fhe-wish-pool"
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/frontend"
PORT=3000

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查依赖
check_dependencies() {
    log_info "检查系统依赖..."

    if ! command -v node &> /dev/null; then
        log_error "Node.js 未安装，请先安装 Node.js 18+"
        exit 1
    fi

    if ! command -v npm &> /dev/null; then
        log_error "npm 未安装"
        exit 1
    fi

    # 检查Node.js版本
    NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        log_error "需要 Node.js 18+，当前版本: $(node -v)"
        exit 1
    fi

    log_info "Node.js 版本: $(node -v)"
    log_info "npm 版本: $(npm -v)"
}

# 安装依赖
install_dependencies() {
    log_info "安装生产依赖..."

    cd "$APP_DIR"

    if [ ! -d "node_modules" ]; then
        log_info "安装依赖包..."
        npm ci --production
    else
        log_info "依赖包已存在，跳过安装"
    fi
}

# 构建应用
build_app() {
    log_info "构建生产版本..."

    cd "$APP_DIR"

    if [ ! -d ".next" ]; then
        log_info "运行构建..."
        npm run build
    else
        log_info "构建文件已存在，跳过构建"
    fi
}

# 检查PM2
check_pm2() {
    if ! command -v pm2 &> /dev/null; then
        log_warn "PM2 未安装，建议安装 PM2 以便进程管理"
        log_info "安装命令: npm install -g pm2"
        USE_PM2=false
    else
        USE_PM2=true
        log_info "检测到 PM2，将使用 PM2 管理进程"
    fi
}

# 启动应用
start_app() {
    log_info "启动应用..."

    cd "$APP_DIR"

    if [ "$USE_PM2" = true ]; then
        # 检查是否已经在运行
        if pm2 describe "$APP_NAME" &> /dev/null; then
            log_warn "应用已在运行"
            pm2 restart "$APP_NAME"
        else
            pm2 start "npm run start" --name "$APP_NAME"
        fi

        pm2 save
        log_info "应用已启动 (使用 PM2)"
        log_info "查看日志: pm2 logs $APP_NAME"
        log_info "监控状态: pm2 monit"
    else
        # 检查端口是否被占用
        if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
            log_error "端口 $PORT 已被占用"
            exit 1
        fi

        log_info "启动生产服务器..."
        nohup npm run start > app.log 2>&1 &
        echo $! > app.pid

        sleep 3

        if kill -0 $(cat app.pid) 2>/dev/null; then
            log_info "应用已启动 (PID: $(cat app.pid))"
            log_info "日志文件: $APP_DIR/app.log"
        else
            log_error "应用启动失败"
            cat app.log
            exit 1
        fi
    fi
}

# 停止应用
stop_app() {
    log_info "停止应用..."

    if [ "$USE_PM2" = true ]; then
        if pm2 describe "$APP_NAME" &> /dev/null; then
            pm2 stop "$APP_NAME"
            pm2 delete "$APP_NAME"
            pm2 save
            log_info "应用已停止 (PM2)"
        else
            log_warn "应用未在运行"
        fi
    else
        if [ -f "$APP_DIR/app.pid" ]; then
            PID=$(cat "$APP_DIR/app.pid")
            if kill -0 "$PID" 2>/dev/null; then
                kill "$PID"
                log_info "应用已停止 (PID: $PID)"
            else
                log_warn "进程已不存在"
            fi
            rm -f "$APP_DIR/app.pid"
        else
            log_warn "PID文件不存在，应用可能未在运行"
        fi
    fi
}

# 重启应用
restart_app() {
    log_info "重启应用..."
    stop_app
    sleep 2
    start_app
}

# 查看状态
status_app() {
    log_info "应用状态:"

    if [ "$USE_PM2" = true ]; then
        pm2 status "$APP_NAME" 2>/dev/null || log_warn "应用未在PM2中运行"
    else
        if [ -f "$APP_DIR/app.pid" ]; then
            PID=$(cat "$APP_DIR/app.pid")
            if kill -0 "$PID" 2>/dev/null; then
                log_info "应用正在运行 (PID: $PID)"
                log_info "端口: $PORT"
            else
                log_info "应用未在运行 (PID文件存在但进程不存在)"
            fi
        else
            log_info "应用未在运行"
        fi
    fi

    # 检查端口
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
        log_info "端口 $PORT 正在监听"
    else
        log_warn "端口 $PORT 未在监听"
    fi
}

# 显示帮助
show_help() {
    echo "FHEVM Wish Pool DApp - 部署脚本"
    echo ""
    echo "使用方法:"
    echo "  $0 [command]"
    echo ""
    echo "命令:"
    echo "  start     启动应用"
    echo "  stop      停止应用"
    echo "  restart   重启应用"
    echo "  status    查看应用状态"
    echo "  build     构建应用"
    echo "  setup     完整设置 (检查依赖 + 安装 + 构建)"
    echo "  help      显示此帮助信息"
    echo ""
    echo "环境变量:"
    echo "  PORT      服务器端口 (默认: 3000)"
    echo ""
    echo "示例:"
    echo "  $0 start"
    echo "  PORT=8080 $0 start"
}

# 完整设置
setup_app() {
    check_dependencies
    install_dependencies
    build_app
    check_pm2
}

# 主函数
main() {
    # 设置端口
    PORT=${PORT:-3000}

    case "${1:-help}" in
        start)
            check_pm2
            start_app
            ;;
        stop)
            check_pm2
            stop_app
            ;;
        restart)
            check_pm2
            restart_app
            ;;
        status)
            check_pm2
            status_app
            ;;
        build)
            build_app
            ;;
        setup)
            setup_app
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 检查是否以root用户运行
if [ "$EUID" -eq 0 ]; then
    log_warn "不建议以root用户运行应用"
fi

# 运行主函数
main "$@"
