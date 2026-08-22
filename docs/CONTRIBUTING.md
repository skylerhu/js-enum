# Contributing

**English** | **[中文](./CONTRIBUTING.zh.md)**

## Overview

This document is intended for developers and describes the guidelines to follow before and after development.

## Development Environment

    node: ^20.9.0

Common commands:
- Install dependencies: `npm install .`
- Initialize: `npm run prepare`
- Lint: `npm run lint`
- Run tests: `npm run test`
- Build: `npm run build` — produces `dist/index.js` for browser usage
- Publish: `npm publish` — publishes files from the `src` directory

## Submitting a Pull Request

Before submitting a Pull Request, ensure the following:
- Tests are included and pass via `make test`
- Test coverage must be `100%`

The Makefile depends on the `jq` command. On macOS, install it via Homebrew: `brew install jq`.

## Building & Publishing

    make release
