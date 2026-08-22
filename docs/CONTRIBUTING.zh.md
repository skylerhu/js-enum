# 贡献指南

**中文文档** | [English](CONTRIBUTING.md)

## 前言

本文档面向开发者，描述开发前后需要注意的事项。

## 开发环境

    node: ^20.9.0

常用命令：
- 安装依赖 `npm install .`
- 初始化 `npm run prepare`
- 代码检查 `make lint`
- 运行测试 `make test`
- 构建 `make build` — 产出 `dist/index.js` 并更新 `releases/` 版本化文件 + latest 符号链接
- 发版 `make release` — build + `npm publish`

## 提交 Pull Request

提交 Pull Request 之前需要检查以下事项是否完成：
- 需包含测试用例，并通过 `make test`
- 测试覆盖率要求 `100%`

Makefile 中依赖 `jq` 命令，macOS 系统通过 Homebrew 安装即可 `brew install jq`。

## 打包发版

    make release
