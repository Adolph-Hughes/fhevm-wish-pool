# FHEVM 链上投币许愿池 DApp

基于FHEVM（Fully Homomorphic Encryption Virtual Machine）开发的隐私保护许愿池应用。用户可以支付小额代币许愿，愿望以加密形式永久存储在区块链上，只有愿望创建者本人能解密查看自己的愿望。

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

1. **克隆项目**
```bash
git clone <repository-url>
cd zama_wish_making
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

4. **启动前端应用**
```bash
cd ../frontend
# 生成ABI文件
node scripts/genabi.mjs
# 启动开发服务器
npx next dev --turbopack
```

5. **访问应用**
打开浏览器访问 `http://localhost:3000`

## 🎯 使用指南

1. **连接钱包**: 点击"🌟 Connect MetaMask"连接您的钱包
2. **许愿**: 在文本框中输入您的愿望，支付0.001 ETH费用
3. **查看愿望**: 您的愿望将以加密形式显示
4. **解密愿望**: 点击"🔓 Decrypt"按钮查看愿望内容

## 📁 项目结构

```
zama_wish_making/
├── fhevm-hardhat-template/     # 智能合约项目
│   ├── contracts/
│   │   ├── FHECounter.sol     # 示例计数器合约
│   │   └── WishPool.sol       # 许愿池合约
│   ├── deployments/           # 合约部署信息
│   └── ...
├── frontend/                   # Next.js前端应用
│   ├── components/
│   │   ├── WishPoolDemo.tsx   # 主要UI组件
│   │   └── ...
│   ├── hooks/
│   │   └── useWishPool.tsx    # 许愿池业务逻辑
│   ├── fhevm/                 # FHEVM相关工具
│   ├── abi/                   # 生成的合约ABI
│   └── ...
├── Fhevm0.8_Reference.md      # FHEVM开发参考
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
