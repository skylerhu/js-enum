# js-enumerate

[![NPM Version](https://img.shields.io/npm/v/js-enumerate?color=blue)](https://www.npmjs.com/package/js-enumerate)
[![NPM Downloads](https://img.shields.io/npm/dm/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Bundle Size](https://img.shields.io/bundlephobia/minzip/js-enumerate)](https://bundlephobia.com/package/js-enumerate)
[![Node Version](https://img.shields.io/node/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![GitHub Actions Workflow Status](https://github.com/skylerhu/js-enum/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/skylerhu/js-enum/actions/workflows/test.yml)
[![codecov](https://codecov.io/github/skylerhu/js-enum/graph/badge.svg?token=4EH2MHP83H)](https://codecov.io/github/skylerhu/js-enum)
[![GitHub License](https://img.shields.io/github/license/skylerhu/js-enum)](https://github.com/skylerhu/js-enum/blob/master/LICENSE)

> A JavaScript enum utility for Node.js and browser environments.
>
> 一个用于 Node.js 与浏览器的 JavaScript 枚举工具。

`js-enumerate` supports building Enum instances from arrays or objects, provides built-in member validation and immutable freezing, and offers frontend-friendly `options`/`filters` transformations for radios, checkboxes, selects, and table filters.

支持通过对象或数组快速构建 Enum 实例，内置成员校验与只读冻结能力，并提供 `options`/`filters` 等前端友好的数据转换方法，便于在单选、多选、下拉和表格筛选等组件中复用统一的枚举定义。

---



## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Constructor](#constructor)
  - [Global Register](#global-register)
  - [Basic Usage](#basic-usage)
  - [Frontend Components](#frontend-components)
  - [Extended Usage](#extended-usage)
  - [Built-in Properties](#built-in-properties)
  - [API Reference](#api-reference)
- [Notes](#notes)
- [Related Projects](#related-projects)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)

---



## Installation



### Node.js

```bash
npm install js-enumerate
```

```javascript
import Enum from 'js-enumerate';

new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);

new Enum({
  Red: 'red',
  green: 'green',
});
```



### Browser

```html
<script src="releases/js-enumerate-latest.min.js"></script>
<script>
    new Enum([{ key: 'RED', value: 'red', label: '红色' }]);
</script>
```

> 可自行将 [releases/js-enumerate-latest.min.js](./releases/js-enumerate-latest.min.js) 上传到 CDN 或拷贝到项目里引用。

---



## Quick Start

```javascript
import Enum from 'js-enumerate';

const Status = new Enum([
  { key: 'ACTIVE', value: 1, label: '启用' },
  { key: 'INACTIVE', value: 0, label: '禁用' },
]);

Status.ACTIVE;           // 1
Status.has(1);           // true
Status.getLabel(1);      // '启用'
Status.options;          // [{ label: '启用', value: 1 }, { label: '禁用', value: 0 }]
```

---



## Usage



### Constructor

```javascript
new Enum(data, options)
```

**Parameters:**


| Parameter | Type               | Description | Default |
| --------- | ------------------ | ----------- | ------- |
| `data`    | `array` / `object` | 枚举成员数据      | —       |
| `options` | `object`           | 配置选项        | —       |


**Options:**


| Parameter         | Type      | Description                           | Default                                    |
| ----------------- | --------- | ------------------------------------- | ------------------------------------------ |
| `freez`           | `boolean` | 是否冻结枚举实例及成员（冻结后不可修改）                  | `true`                                     |
| `allDefaultValue` | `object`  | "全部"选项的默认值（用于 `filters`/`getOptions`） | `{ key: '__ALL', value: '', label: '全部' }` |


> **Note:** 参数名为 `freez`（库内既有命名），不是 `freeze`。



### Global Register

```javascript
// Node.js: global.Enum | Browser: window.Enum
Enum.register();
// 自定义名称
Enum.register("JsEnum"); // window.JsEnum
```



### Basic Usage

```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);

Color.RED;    // 'red'
Color.GREEN;  // 'green'
Color.length; // 2

Color.toJSON();
// [{"key":"RED","value":"red","label":"红色"},{"key":"GREEN","value":"green","label":"绿色"}]

JSON.stringify(Color);
// '[{"key":"RED","value":"red","label":"红色"},{"key":"GREEN","value":"green","label":"绿色"}]'

// 获取成员
const member = Color.getMember('red');
member.value; // 'red'
member.key;   // 'RED'
member.label; // '红色'
Color.getLabel(Color.RED); // '红色'

// 判断枚举值是否合法
Color.has('red');    // true
Color.has('yellow'); // false

// 迭代
Color.map(member => member.label); // ['红色', '绿色']
Object.keys(Color); // ['RED', 'GREEN']

for (const key in Color) {
  console.log(key);    // 遍历 keys
}
for (const member of Color) {
  console.log(member); // 遍历成员对象
}

// 字典构造
const ColorV2 = new Enum({ Red: 'red', green: 'green' });
ColorV2.Red;   // 'red'
ColorV2.green; // 'green'
ColorV2.toJSON();
// [{"key":"Red","value":"red"},{"key":"green","value":"green"}]
```



### Frontend Components

以 `React + Ant Design` 为例：

```jsx
import React from 'react';
import { Select, Radio, Table } from 'antd';
import Enum from 'js-enumerate';

const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
]);

const App = () => (
  <>
    {/* filters 默认包含"全部"选项 */}
    <Select defaultValue={Color.RED} options={Color.filters} />
    <Radio.Group defaultValue={Color.GREEN} options={Color.options} />
    {/* toFilters() 适配 Antd Table filters: { text, value } */}
    <Table columns={[{ key: 'color', title: '颜色', filters: Color.toFilters() }]} />
  </>
);
```



### Extended Usage

```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: '红色', disabled: true, color: '#f00' },
  { key: 'GREEN', value: 'green', label: '绿色', extra: { msg: '其他信息' }, color: '#0f0' },
]);

const redMem = Color.getMember(Color.RED);
redMem.disabled; // true
redMem.color;    // '#f00'

const greenMem = Color.getMember(Color.GREEN);
greenMem.extra;  // { msg: '其他信息' }

// 冻结后写操作会抛出错误
Color.RED = 'red-v2';     // Throws Error
delete Color.RED;         // Throws Error
redMem.label = '大红色';  // Throws Error

// 可通过 options.freez 关闭冻结（不建议）
const ColorEdit = new Enum([
  { key: 'RED', value: 'red', label: '红色' },
  { key: 'GREEN', value: 'green', label: '绿色' },
], { freez: false });

const redEdit = ColorEdit.getMember(ColorEdit.RED);
redEdit.label = '大红色'; // OK
redEdit.label;            // '大红色'
```



### Built-in Properties


| Property  | Description                                      |
| --------- | ------------------------------------------------ |
| `length`  | 枚举实例所有成员个数                                       |
| `options` | 不包含"全部"选项，等价于 `getOptions({ enableAll: false })` |
| `filters` | 包含"全部"选项，等价于 `getOptions()`                      |




### API Reference


| Method                 | Description                                                         |
| ---------------------- | ------------------------------------------------------------------- |
| `forEach(fn)`          | 对枚举成员进行遍历                                                           |
| `map(fn)`              | 对枚举成员进行映射                                                           |
| `filter(fn)`           | 对枚举成员进行过滤                                                           |
| `getMember(value)`     | 通过 value 获取成员对象                                                     |
| `has(value)`           | 判断 value 是否为合法枚举值                                                   |
| `getLabel(value)`      | 通过 value 获取成员 label                                                 |
| `toJSON()`             | 返回枚举成员数组，支持 `JSON.stringify()`                                      |
| `toFilters(options?)`  | 转换为 Ant Design / Element 的 table filters 格式 `{ text, value }`       |
| `getOptions(options?)` | 返回选项数组，支持 `enableAll` / `keyValue` / `keyLabel` / `allDefaultValue` |
| `Enum.register(key?)`  | 静态方法，全局注册 Enum 对象                                                   |


> `to_filters()` 已废弃，请使用 `toFilters()`。

---



## Notes

- 成员 `key` 只能由数字、大小写字母、中横线、下划线组成，且不能以 `__` 开头
- 成员 `key` 不能使用内置属性名（如 `length`/`options`/`filters`）
- 成员 `value` 不能为 `null` 或 `undefined`
- 成员 `label` 不能为 `null` 或 `''`；未传 `label` 时展示默认回退为 `value`
- 枚举实例成员默认被 `freez` 冻结，不允许修改

---



## Related Projects

- [py-enum](https://github.com/SkylerHu/py-enum) — Python 枚举工具，推荐与本库配合使用

---



## Contributing

欢迎贡献代码！请阅读 [Contributing Guide](./docs/CONTRIBUTING.md) 了解开发流程和规范。

---



## Changelog

查看版本变更记录：[CHANGELOG](./docs/CHANGELOG-1.x.md)

---



## License

[MIT](./LICENSE) © [SkylerHu](https://github.com/skylerhu)