# FHEVM Wish Pool - Privacy-Preserving Blockchain Wish Making DApp

[![GitHub Repo](https://img.shields.io/badge/GitHub-Adolph--Hughes/fhevm--wish--pool-blue?style=flat&logo=github)](https://github.com/Adolph-Hughes/fhevm-wish-pool)
[![FHEVM](https://img.shields.io/badge/FHEVM-Zama-purple?style=flat)](https://www.zama.ai/)
[![License](https://img.shields.io/badge/License-BSD--3--Clause--Clear-green?style=flat)](./LICENSE)

A privacy-preserving wish-making DApp built on FHEVM (Fully Homomorphic Encryption Virtual Machine). Users can make wishes by paying a small token fee, with wishes stored encrypted on the blockchain. Only the wish creator can decrypt and view their own wishes.

## ✨ 核心特性

- 🔒 **隐私保护**: 愿望内容使用FHE加密，只有创建者能解密
- 💎 **区块链存储**: 愿望永久保存在区块链上，不可篡改
- 💰 **小额支付**: 0.001 ETH许愿费用
- 🎨 **美观界面**: 现代化的渐变UI设计
- 🔄 **实时交互**: 支持MetaMask钱包连接

## 🏗️ 技术架构

### 智能合约 (Solidity + FHEVM)
- **WishPool.sol**: 主要的许愿池合约
- **FHE数据类型**: 使用`euint256`等加密类型存储数据
- **访问控制**: 通过FHE ACL确保只有创建者能访问自己的愿望

### 前端 (Next.js + TypeScript + Tailwind CSS)
- **React Hooks**: 自定义的`useWishPool` hook管理区块链交互
- **FHEVM SDK**: 使用`@zama-fhe/relayer-sdk`进行加密操作
- **Mock模式**: 支持本地开发和测试

## 🚀 快速开始

### 环境要求
- Node.js 18+
- npm 或 yarn
- MetaMask钱包

### 安装和运行

#### 方式1: 完整开发环境

1. **克隆项目**
```bash
git clone https://github.com/Adolph-Hughes/fhevm-wish-pool.git
cd fhevm-wish-pool
```

2. **启动本地Hardhat节点**
```bash
cd fhevm-hardhat-template
npm install
npx hardhat node --verbose
```

3. **部署合约**
```bash
npx hardhat deploy --network localhost
```

#### 方式2: 静态部署 (推荐用于演示)

1. **下载静态文件**
```bash
# 从GitHub下载或使用本地文件
cd static-deployment
```

2. **本地测试**
```bash
./deploy.sh local
# 访问 http://localhost:8000
```

3. **部署到生产环境**
```bash
# Vercel
./deploy.sh vercel

# 或Netlify
./deploy.sh netlify
```

## 🎯 使用指南

1. **连接钱包**: 点击"🌟 Connect MetaMask"连接您的钱包
2. **许愿**: 在文本框中输入您的愿望，支付0.001 ETH费用
3. **查看愿望**: 您的愿望将以加密形式显示
4. **解密愿望**: 点击"🔓 Decrypt"按钮查看愿望内容

## 📁 项目结构

```
fhevm-wish-pool/
├── fhevm-hardhat-template/     # 智能合约项目 (Hardhat + FHEVM)
│   ├── contracts/
│   │   ├── FHECounter.sol     # 示例FHE计数器合约
│   │   └── WishPool.sol       # 隐私许愿池合约
│   ├── deployments/           # 合约部署信息
│   ├── test/                  # 合约测试
│   └── ...
├── deployment/                 # 部署脚本和配置
├── static-deployment/          # 静态文件部署包
│   ├── index.html             # 主页面
│   ├── _next/                 # Next.js静态资源
│   ├── deploy.sh              # 部署脚本
│   └── README.md              # 部署指南
├── DEPLOYMENT.md              # 详细部署文档
├── PROJECT_INTRO.md           # 英文项目介绍
├── deploy-production.sh       # 生产环境部署脚本
├── .gitignore                 # Git忽略规则
└── README.md                  # 本文件
```

## 🔧 开发要点

### FHEVM合约开发
- 使用`SepoliaConfig`配置网络
- 加密数据类型：`euint8/16/32/64/128/256`, `ebool`, `eaddress`
- 访问控制：`FHE.allow()`设置数据访问权限
- 加密输入：`FHE.fromExternal()`转换外部加密输入

### 前端集成
- **SDK加载**: 使用`RelayerSDKLoader`动态加载FHEVM SDK
- **实例创建**: `createFhevmInstance()`初始化FHEVM实例
- **加密操作**: `instance.createEncryptedInput()`创建加密输入
- **解密操作**: `instance.userDecrypt()`解密数据

### Mock模式开发
- 本地开发时自动使用`@fhevm/mock-utils`
- 无需真实网络环境即可测试FHE功能
- 通过检测Hardhat节点自动启用

## 🔐 隐私保护机制

1. **愿望加密**: 用户输入的愿望通过FHE公钥加密
2. **存储加密**: 区块链上只存储加密后的密文
3. **访问控制**: 只有愿望创建者有解密权限
4. **零知识证明**: 加密操作使用ZKPoK验证

## 🎨 UI设计特色

- **渐变背景**: 紫色到粉色到青色的现代渐变
- **卡片设计**: 圆角阴影卡片，hover效果
- **图标装饰**: 使用emoji图标增强视觉效果
- **响应式布局**: 支持移动端和桌面端
- **状态反馈**: 实时显示操作状态和错误信息

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 📄 许可证

BSD-3-Clause-Clear License

## 🙏 致谢

- [Zama](https://www.zama.ai/) - FHEVM技术提供者
- [FHEVM React Template](https://github.com/zama-ai/fhevm-react-template) - 项目模板基础
