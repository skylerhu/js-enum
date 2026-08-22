# Contributing

[中文文档](CONTRIBUTING.zh.md) | **English**

## Overview

This document is intended for developers and describes the guidelines to follow before and after development.

## Development Environment

    node: ^20.9.0

Common commands:
- Install dependencies: `npm install .`
- Initialize: `npm run prepare`
- Lint: `make lint`
- Run tests: `make test`
- Build: `make build` — produces `dist/index.js` and updates `releases/` with versioned file + latest symlink
- Release: `make release` — build + `npm publish`

## Submitting a Pull Request

Before submitting a Pull Request, ensure the following:
- Tests are included and pass via `make test`
- Test coverage must be `100%`

The Makefile depends on the `jq` command. On macOS, install it via Homebrew: `brew install jq`.

## Building & Publishing

    make release
