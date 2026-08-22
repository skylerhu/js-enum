# 贡献指南

**[English](./CONTRIBUTING.md)** | **中文**

## 前言

本文档面向开发者，描述开发前后需要注意的事项。

## 开发环境

    node: ^20.9.0

常用命令：
- 安装依赖 `npm install .`
- 初始化 `npm run prepare`
- 代码格式 `npm run lint`
- 测试用例 `npm run test`
- 构建 `npm run build` 构建出来的 `dist/index.js` 可用于浏览器环境使用
- 发版 `npm publish` 直接使用 `src` 目录下的文件发版

## 提交 Pull Request

提交 Pull Request 之前需要检查以下事项是否完成：
- 需包含测试用例，并通过 `make test`
- 测试覆盖率要求 `100%`

Makefile 中依赖 `jq` 命令，macOS 系统通过 Homebrew 安装即可 `brew install jq`。

## 打包发版

    make release
