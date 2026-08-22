# js-enumerate

[![NPM Version](https://img.shields.io/npm/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![NPM Downloads](https://img.shields.io/npm/dm/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Bundle Size](https://img.shields.io/bundlephobia/minzip/js-enumerate)](https://bundlephobia.com/package/js-enumerate)
[![Node Version](https://img.shields.io/node/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Test](https://github.com/skylerhu/js-enum/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/skylerhu/js-enum/actions/workflows/test.yml)
[![Codecov](https://codecov.io/gh/skylerhu/js-enum/graph/badge.svg)](https://codecov.io/gh/skylerhu/js-enum)
[![License](https://img.shields.io/github/license/skylerhu/js-enum)](https://github.com/skylerhu/js-enum/blob/master/LICENSE)

**[English](./README.md)** | **中文**

一个适用于 **Node.js** 和**浏览器**的 JavaScript 枚举工具。支持通过数组或对象快速构建类型安全、不可变的 Enum 实例，内置校验、迭代能力，并提供前端友好的数据转换方法，适用于下拉框、单选、多选、表格筛选等场景。

## 特性

- 支持**数组**和**普通对象**两种构造方式
- 成员默认**冻结**（不可变）
- 内置 `has()`、`getMember()`、`getLabel()` 校验与查找方法
- 可迭代 — 支持 `for...of`、`map`、`forEach`、`filter`
- 前端友好的 `options` / `filters` / `toFilters()`，适配 Ant Design、Element UI 等
- 通过 `Enum.register()` 全局注册
- 同时支持 Node.js (CommonJS) 和浏览器 (UMD)

## 目录

- [安装](#安装)
- [快速开始](#快速开始)
- [使用指南](#使用指南)
  - [构造函数](#构造函数)
  - [全局注册](#全局注册)
  - [前端组件集成](#前端组件集成)
  - [扩展用法](#扩展用法)
- [API 参考](#api-参考)
  - [属性](#属性)
  - [方法](#方法)
- [注意事项](#注意事项)
- [贡献](#贡献)
- [变更日志](#变更日志)
- [许可证](#许可证)
- [相关项目](#相关项目)

## 安装

```bash
npm install js-enumerate
```

浏览器环境可直接引入 UMD 打包文件：

```html
<script src="releases/js-enumerate-latest.min.js"></script>
```

> 可将 [releases/js-enumerate-latest.min.js](./releases/js-enumerate-latest.min.js) 上传至 CDN 或拷贝到项目中引用。

## 快速开始

```javascript
import Enum from 'js-enumerate';

const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);

Color.RED           // 'red'
Color.GREEN         // 'green'
Color.length        // 2
Color.has('red')    // true
Color.getLabel('red') // '红色'

// 迭代
Color.map(m => m.label); // ['红色', '绿色']

// 通过普通对象构造
const Status = new Enum({ Active: 1, Inactive: 0 });
Status.Active  // 1
```

## 使用指南

### 构造函数

```javascript
new Enum(data, options)
```

| 参数 | 类型 | 说明 | 默认值 |
| --- | --- | --- | --- |
| data | array / object | 枚举成员数据 | — |
| options | object | 配置选项 | — |

**options 参数：**

| 参数 | 类型 | 说明 | 默认值 |
| --- | --- | --- | --- |
| freez | boolean | 是否冻结枚举实例及成员（冻结后不可修改） | `true` |
| allDefaultValue | object | "全部"选项的默认值（用于 `filters` / `getOptions`） | `{ key: '__ALL', value: '', label: '全部' }` |

> 注意：参数名为 `freez`（库内既有命名），不是 `freeze`。

### 全局注册

```javascript
Enum.register();       // global.Enum (Node.js) / window.Enum (浏览器)
Enum.register('JsEnum'); // window.JsEnum
```

### 前端组件集成

以 **React + Ant Design** 为例：

```jsx
import Enum from 'js-enumerate';
import { Select, Radio, Table } from 'antd';

const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);

const App = () => (
  <>
    <Select defaultValue={Color.RED} options={Color.filters} />
    <Radio.Group defaultValue={Color.GREEN} options={Color.options} />
    <Table columns={[{ key: 'color', title: '颜色', filters: Color.toFilters() }]} />
  </>
);
```

### 扩展用法

```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色', disabled: true, color: '#f00' },
  { key: 'GREEN', value: 'green', label: '绿色', extra: { msg: '其他信息' }, color: '#0f0' },
]);

Color.getMember('red').disabled // true
Color.getMember('green').extra  // { msg: '其他信息' }

// 默认冻结 — 写操作会抛出异常
Color.RED = 'new'; // Throws Error

// 通过 freez 取消冻结（不推荐）
const Mutable = new Enum([
  { key: 'A', value: 1, label: 'Alpha' },
], { freez: false });
```

## API 参考

### 属性

| 属性 | 说明 |
| --- | --- |
| `length` | 枚举成员总数 |
| `options` | 不含"全部"选项的成员列表，等价于 `getOptions({ enableAll: false })` |
| `filters` | 包含"全部"选项的成员列表，等价于 `getOptions()` |

### 方法

| 方法 | 说明 |
| --- | --- |
| `has(value)` | 判断值是否存在于枚举中 |
| `getMember(value)` | 通过 value 获取成员对象 |
| `getLabel(value)` | 通过 value 获取成员的 label |
| `forEach(fn)` | 遍历枚举成员 |
| `map(fn)` | 映射枚举成员并返回数组 |
| `filter(fn)` | 过滤枚举成员并返回数组 |
| `toJSON()` | 返回成员数组，兼容 `JSON.stringify()` |
| `toFilters(options?)` | 转换为 Ant Design / Element 表格筛选格式（`{ text, value }`，默认不含"全部"） |
| `getOptions(options?)` | 返回成员数组，支持通过 `enableAll` / `keyValue` / `keyLabel` / `allDefaultValue` 自定义 |
| `Enum.register(key?)` | 静态方法 — 全局注册 Enum（默认 key 为 `'Enum'`） |

> `to_filters()` 为 `toFilters()` 的旧别名（已废弃），将在未来版本移除。

## 注意事项

- 成员 `key` 只能包含字母、数字、中横线、下划线，且不能以 `__` 开头。
- 成员 `key` 不能使用保留属性名：`length`、`options`、`filters`。
- 成员 `value` 不能为 `null` 或 `undefined`。
- 成员 `label` 不能为 `null` 或 `''`；若不传 `label`，展示时回退为 `value`。
- 枚举实例默认冻结（`freez: true`），不允许修改。

## 贡献

请参阅 [贡献指南](./docs/CONTRIBUTING.zh.md) 了解开发环境搭建与贡献规范。

## 变更日志

请参阅 [变更日志](./docs/CHANGELOG-1.x.zh.md) 了解版本历史。

## 许可证

[MIT](./LICENSE)

## 相关项目

- [py-enum](https://github.com/skylerhu/py-enum) — Python 枚举工具，API 风格一致，适合全栈项目统一枚举定义。
