# js-enumerate

[![NPM Version](https://img.shields.io/npm/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![NPM Downloads](https://img.shields.io/npm/dm/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Bundle Size](https://img.shields.io/bundlephobia/minzip/js-enumerate)](https://bundlephobia.com/package/js-enumerate)
[![Node Version](https://img.shields.io/node/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Test](https://github.com/SkylerHu/js-enum/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/SkylerHu/js-enum/actions/workflows/test.yml)
[![Coveralls](https://img.shields.io/coverallsCoverage/github/SkylerHu/js-enum)](https://coveralls.io/github/SkylerHu/js-enum)
[![License](https://img.shields.io/github/license/SkylerHu/js-enum)](https://github.com/SkylerHu/js-enum/blob/master/LICENSE)

**[English](./README.md)** | **中文**

## 简介

`js-enumerate` 是一个可在 Node.js 与浏览器环境运行的 JavaScript 枚举工具。它支持通过对象或数组快速构建 Enum 实例，内置成员校验与只读冻结能力，并提供 `options`/`filters` 等前端友好的数据转换方法，便于在单选、多选、下拉和表格筛选等组件中复用统一的枚举定义。

## 1. 安装

可查看版本变更记录 [变更日志](./docs/CHANGELOG-1.x.zh.md)

### 1.1 Node.js

	npm install js-enumerate

```javascript
import Enum from 'js-enumerate';

new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);
// 也可使用字典构造
new Enum({
  Red: 'red',
  green: 'green',
});
```

### 1.2 浏览器

```html
<script src="releases/js-enumerate-latest.min.js"></script>
<script>
    new Enum([{ key: 'RED', value: 'red', label: '红色' }]);
</script>
```

> 提示：可自行将 [releases/js-enumerate-latest.min.js](./releases/js-enumerate-latest.min.js) 文件上传到 CDN、或者拷贝到项目里引用。

## 2. 使用

### 2.1 构造函数

    new Enum(data, options)

参数说明：

| 参数 | 类型 | 说明 | 默认值 | 版本 |
| - | - | - | - | - |
| data | array/object | 初始化枚举成员 | | |
| options | object | 配置选项 | | |

options 参数说明：

| 参数 | 类型 | 说明 | 默认值 | 版本 |
| - | - | - | - | - |
| freez | boolean | 是否冻结枚举实例及成员（冻结后不可修改） | true |  |
| allDefaultValue | object | 定义"全部"选项的默认值（用于 `filters`/`getOptions`） | { key: '__ALL', value: '', label: '全部' } |  |

> 注意：参数名为 `freez`（库内既有命名），不是 `freeze`。


### 2.2 全局注册
```javascript
// 在 Node.js 中定义 global.Enum
// 在浏览器中定义 window.Enum
Enum.register();
// 可以通过 key 更改对象的名称
Enum.register("JsEnum"); // window.JsEnum
```

### 2.3 基础用法
```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);
// 使用成员值
Color.RED // 'red'
Color.GREEN // 'green'
// 成员个数
Color.length // 2

Color.toJSON(); // 返回数组 [{"key":"RED","value":"red","label":"红色"},{"key":"GREEN","value":"green","label":"绿色"}]
JSON.stringify(Color); // 返回字符串 '[{"key":"RED","value":"red","label":"红色"},{"key":"GREEN","value":"green","label":"绿色"}]'

// 获取成员
const member = Color.getMember('red'); // 返回单个成员对象 {"key":"RED","value":"red","label":"红色"}
member.value === 'red'; // true
member.key; // 'RED'
member.label; // '红色'
Color.getLabel(Color.RED); // '红色'

// 判断枚举值是否合法
Color.has('red'); // true
Color.has('yellow'); // false

// map、forEach 和 filter 函数都可直接使用
Color.map(member => member.label); // ['红色', '绿色']
// 属性成员来自定义枚举的 key
Object.keys(Color); // ['RED', 'GREEN']
// 用 in 是遍历 keys
for (const key in Color) {
  console.log(key);
}
// 用 of 是遍历成员对象
for (const member of Color) {
  console.log(member);
}

// 使用字典构造
const ColorV2 = new Enum({
  Red: 'red',
  green: 'green',
});
ColorV2.toJSON(); // [{"key":"Red","value":"red"},{"key":"green","value":"green"}]
// 注意区分大小写，字典属性字段为成员的 key
ColorV2.Red // 'red'
ColorV2.green // 'green'
```

### 2.4 前端组件中使用
使用 `React + Ant Design` 举例：
```jsx
import React from 'react';
import { Select, Radio, Table } from 'antd';
// 可以直接在 index.js 入口文件中执行 Enum.register()，即可全局使用
import Enum from 'js-enumerate';

const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);
// 依次应用于下拉选项、单选框、表格字段的筛选菜单项
const App = () => (
  <>
    {/* filters 默认包含"全部"选项 */}
    <Select defaultValue={Color.RED} options={Color.filters} />
    <Radio.Group defaultValue={Color.GREEN} options={Color.options} />
    {/* toFilters() 适配 Antd Table filters: { text, value } */}
    <Table columns={[{ key: 'color', title: '颜色', filters: Color.toFilters() }]}/>
  </>
);
```

### 2.5 其他扩展用法
```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色', disabled: true, color: '#f00' },
  { key: 'GREEN', value: 'green', label: '绿色', extra: { msg: '其他信息' }, color: '#0f0' },
]);
const redMem = Color.getMember(Color.RED);
redMem.disabled // true
redMem.color // '#f00'
const greenMem = Color.getMember(Color.GREEN);
greenMem.extra // { msg: '其他信息' }

// 以下非读操作会报错
Color.RED = 'red-v2'; // Throws Error
delete Color.RED; // Throws Error
redMem.label = '大红色'; // Throws Error

// 可以通过 options.freez 不冻结枚举实例
// 但不建议这么使用，容易出现不可预期的事情
const ColorEdit = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
], { freez: false });
const redEdit = ColorEdit.getMember(ColorEdit.RED);
redEdit.label // '红色'
redEdit.label = '大红色' // true
redEdit.label // '大红色'
```

### 2.6 内置属性
- `length` 枚举实例所有成员个数
- `options` 不包含"全部"选项，等价于 `getOptions({ enableAll: false })`
- `filters` 包含"全部"选项，等价于 `getOptions()`

### 2.7 枚举对象 API
- `forEach`、`map`、`filter` 这三个方法是对枚举成员迭代器进行遍历操作
- `getMember(value)` 通过 value 获取成员对象
- `has(value)` 值 value 是否在枚举定义的成员当中
- `getLabel(value)` 通过 value 获取成员 label 用于展示
- `toJSON()` 返回当前枚举成员数组，可直接被 `JSON.stringify()` 调用
- `toFilters(options = {})` 转换成 Ant Design / Element 的 Table `filters` 数据（默认键名为 `text`/`value`，且不包含"全部"）
- `to_filters(options = {})` 兼容旧方法（已废弃，内部会提示使用 `toFilters`）
- `getOptions(options = {})` 根据所有成员信息返回数组数据，可通过 `enableAll`/`keyValue`/`keyLabel`/`allDefaultValue` 自定义
- `Enum.register(key = 'Enum')` 类的静态方法，用于全局注册对象

### 2.8 其他注意事项
- 成员 key 属性只能由数字、大小写字母、中横线、下划线组成的`字符串`，且不能以 `__` 开头；
- 成员 key 属性不能使用内置属性字符串，例如 `length`/`options`/`filters` 不能使用；
- 成员 `value` 不能为 `null` 和 `undefined`；
- 成员 `label` 不能为 `null` 和 `''`；若不传 `label`，展示时默认回退为 `value`；
- 枚举实例成员默认都被 `freez` 冻结，不允许修改；


## 3. 推荐
- 若后端使用 Python 语言，推荐 [py-enum](https://github.com/SkylerHu/py-enum) 配合该库一起使用
