# FHEVM Wish Pool DApp - 部署指南

## 📦 构建状态

✅ **构建完成**: 前端应用已成功打包为生产版本

### 构建信息
- **Next.js版本**: 15.5.4
- **构建大小**: 212 kB (首屏加载)
- **页面**: 5个静态页面
- **状态**: 生产就绪

## 🚀 部署方式

### 方法1: Node.js服务器部署 (推荐)

#### 1. 准备环境
```bash
# 确保Node.js 18+ 已安装
node --version
npm --version
```

#### 2. 部署到服务器
```bash
# 1. 上传项目文件到服务器
scp -r zama_wish_making user@your-server:/path/to/app

# 2. 在服务器上安装依赖
cd /path/to/app/frontend
npm ci --production

# 3. 构建应用 (如果需要重新构建)
npm run build

# 4. 启动生产服务器
npm run start

# 或者使用PM2管理进程
npm install -g pm2
pm2 start "npm run start" --name "fhe-wish-pool"
```

#### 3. 配置反向代理 (Nginx)
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 方法2: Vercel部署 (推荐用于快速部署)

#### 1. 安装Vercel CLI
```bash
npm install -g vercel
```

#### 2. 部署到Vercel
```bash
cd frontend
vercel --prod

# 或者使用GitHub集成
# 推送代码到GitHub，然后在Vercel中导入项目
```

#### 3. 配置环境变量
在Vercel控制台中设置：
```
INFURA_API_KEY=your_infura_key
MNEMONIC=your_mnemonic (如果需要)
```

### 方法3: Docker部署

#### 1. 创建Dockerfile
```dockerfile
FROM node:18-alpine

WORKDIR /app

# 复制package.json
COPY package*.json ./
RUN npm ci --only=production

# 复制构建文件
COPY .next .next
COPY public public
COPY next.config.ts ./

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "run", "start"]
```

#### 2. 构建和运行
```bash
cd frontend
docker build -t fhe-wish-pool .
docker run -p 3000:3000 fhe-wish-pool
```

## 🌐 网络配置

### 支持的网络
- **Sepolia (11155111)**: 完整FHEVM支持
- **Hardhat (31337)**: Mock模式
- **其他网络**: 自动Mock模式

### MetaMask配置
用户需要手动添加Sepolia网络：
- **网络名称**: Sepolia
- **RPC URL**: `https://sepolia.infura.io/v3/YOUR_INFURA_KEY`
- **Chain ID**: 11155111
- **货币符号**: SepoliaETH

## 🔧 环境变量

### 必需变量
```bash
# Infura API Key (用于Sepolia RPC)
INFURA_API_KEY=your_infura_key_here
```

### 可选变量
```bash
# Hardhat mnemonic (仅开发环境)
MNEMONIC="test test test test test test test test test test test junk"
```

## 📊 性能优化

### 构建优化
- ✅ 已启用代码分割
- ✅ 已优化图片和字体
- ✅ 已压缩JavaScript/CSS
- ✅ 已启用Service Worker缓存

### 运行时优化
- **首屏加载**: 212 kB
- **核心功能**: 102 kB (共享代码)
- **FHEVM SDK**: 动态加载
- **区块链交互**: 按需加载

## 🔒 安全考虑

### HTTPS配置
```nginx
# 强制HTTPS
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    # SSL证书配置
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    # 其他配置...
}
```

### CSP头
```nginx
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.zama.ai; connect-src 'self' https://sepolia.infura.io wss://sepolia.infura.io; style-src 'self' 'unsafe-inline';" always;
```

## 🧪 测试部署

### 本地测试生产版本
```bash
cd frontend
npm run build
npm run start
# 访问 http://localhost:3000
```

### 功能测试清单
- [ ] MetaMask连接
- [ ] 网络切换
- [ ] 许愿功能
- [ ] 解密功能
- [ ] 响应式设计

## 📈 监控和维护

### 日志监控
```bash
# 查看应用日志
pm2 logs fhe-wish-pool

# Vercel日志
vercel logs your-deployment-url
```

### 性能监控
- 使用Lighthouse测试性能
- 监控区块链RPC调用
- 跟踪用户交互指标

## 🚨 故障排除

### 常见问题

#### 1. 构建失败
```bash
# 清理缓存重新构建
rm -rf .next node_modules/.cache
npm run build
```

#### 2. FHEVM SDK加载失败
- 检查网络连接
- 验证CDN可用性
- 检查浏览器兼容性

#### 3. MetaMask连接问题
- 确保HTTPS环境
- 检查网络配置
- 验证Infura API Key

#### 4. 合约交互失败
- 检查网络连接
- 验证合约地址
- 确认钱包中有足够代币

## 🎯 部署检查清单

- [ ] 环境变量配置完成
- [ ] 合约地址正确
- [ ] 网络配置正确
- [ ] HTTPS证书配置
- [ ] 防火墙规则设置
- [ ] 监控和日志配置
- [ ] 备份策略制定

## 📞 支持

如果遇到部署问题，请检查：
1. 控制台错误信息
2. 网络连接状态
3. 合约部署状态
4. MetaMask配置

---

**🎉 您的FHEVM Wish Pool DApp已准备好迎接用户！**
