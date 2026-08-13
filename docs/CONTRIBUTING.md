# Contributing Guide

感谢你对本项目的关注！以下是开发和贡献的流程说明。

## Prerequisites

| Tool | Version | Description |
| --- | --- | --- |
| Node.js | `^20.9.0` | 运行环境 |
| npm | 随 Node.js 安装 | 包管理器 |
| jq | latest | Makefile 中用于解析 `package.json` |
| Python | 3.x | Makefile help 脚本依赖 |

**macOS 安装 jq：**

```bash
brew install jq
```

## Getting Started

```bash
# 克隆仓库
git clone git@github.com:skylerhu/js-enum.git
cd js-enum

# 安装依赖
npm install

# 初始化 Git Hooks (husky)
npm run prepare
```

## Development Workflow

### 常用 npm 命令

| Command | Description |
| --- | --- |
| `npm run lint` | ESLint 代码风格检查 |
| `npm run lint:fix` | 自动修复 lint 问题 |
| `npm run test` | 运行测试用例 (Jest) |
| `npm run test-cov` | 运行测试并上报覆盖率 |
| `npm run build` | Webpack 构建浏览器版本到 `dist/` |

### Makefile Targets

项目提供了 Makefile 以简化常见操作：

| Target | Description |
| --- | --- |
| `make help` | 查看所有可用的 make 命令 |
| `make clean` | 清除所有构建、测试产物 |
| `make clean-build` | 清除 `dist/` 构建产物 |
| `make clean-install` | 清除 `node_modules/` 和 `package-lock.json` |
| `make clean-test` | 清除 `.coverage` 测试覆盖率产物 |
| `make lint` | 执行 ESLint 代码检查 |
| `make test` | 执行 lint + 测试用例 |
| `make build` | 执行 test + 构建浏览器版本 |
| `make backup` | 构建并备份到 `releases/` 目录（带版本号） |
| `make release` | 发布到 npm |

## Code Style

- 项目使用 ESLint 进行代码规范检查
- 提交前会通过 `husky` + `lint-staged` 自动检查
- Commit message 遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范（由 `@commitlint` 校验）

## Testing

```bash
# 运行全量测试
make test

# 仅运行测试（不含 lint）
npm run test
```

- 测试框架：Jest
- 覆盖率要求：**100%**
- 所有新增功能必须包含对应的测试用例

## Pull Request Checklist

提交 PR 前请确认：

- [ ] 代码通过 `make test`（包含 lint + 测试）
- [ ] 测试覆盖率保持 100%
- [ ] Commit message 符合 Conventional Commits 规范
- [ ] 如有新特性，已更新相关文档

## Build & Release

构建产物用于浏览器环境（`dist/index.js`），发版使用 `src/` 目录下的源文件。

```bash
# 构建浏览器版本
make build

# 备份构建产物到 releases/ (带版本号 + latest)
make backup

# 发布到 npm registry
make release
```

## Project Structure

```
js-enum/
├── src/            # 源代码
├── dist/           # 构建产物（浏览器版本）
├── releases/       # 备份的浏览器发行版
├── tests/          # 测试用例
├── docs/           # 文档
├── webpack.config.js
├── package.json
└── Makefile
```
