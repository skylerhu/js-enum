# js-enumerate

[![NPM Version](https://img.shields.io/npm/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![NPM Downloads](https://img.shields.io/npm/dm/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Bundle Size](https://img.shields.io/bundlephobia/minzip/js-enumerate)](https://bundlephobia.com/package/js-enumerate)
[![Node Version](https://img.shields.io/node/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Test](https://github.com/skylerhu/js-enum/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/skylerhu/js-enum/actions/workflows/test.yml)
[![Coveralls](https://img.shields.io/coverallsCoverage/github/skylerhu/js-enum)](https://coveralls.io/github/skylerhu/js-enum)
[![License](https://img.shields.io/github/license/skylerhu/js-enum)](https://github.com/skylerhu/js-enum/blob/master/LICENSE)

**English** | **[中文](./README.zh.md)**

## Introduction

`js-enumerate` is a JavaScript enum utility for both Node.js and browser environments. It supports building Enum instances from arrays or objects, provides built-in member validation and immutable freezing, and offers frontend-friendly `options`/`filters` transformations for radios, checkboxes, selects, and table filters.

## 1. Installation

See [Changelog](./docs/CHANGELOG-1.x.md) for version history.

### 1.1 Node.js

	npm install js-enumerate

```javascript
import Enum from 'js-enumerate';

new Enum([
  { key: 'RED', value: 'red', label: 'Red' },
  { key: 'GREEN', value: 'green', label: 'Green' },
]);
// Or construct from a plain object
new Enum({
  Red: 'red',
  green: 'green',
});
```

### 1.2 Browser

```html
<script src="releases/js-enumerate-latest.min.js"></script>
<script>
    new Enum([{ key: 'RED', value: 'red', label: 'Red' }]);
</script>
```

> Tip: You can upload [releases/js-enumerate-latest.min.js](./releases/js-enumerate-latest.min.js) to your CDN or copy it directly into your project.

## 2. Usage

### 2.1 Constructor

    new Enum(data, options)

Parameters:

| Parameter | Type | Description | Default | Since |
| - | - | - | - | - |
| data | array/object | Initial enum members | | |
| options | object | Configuration options | | |

Options:

| Parameter | Type | Description | Default | Since |
| - | - | - | - | - |
| freez | boolean | Whether to freeze the enum instance and its members (immutable after creation) | true |  |
| allDefaultValue | object | Default value for the "All" option (used by `filters`/`getOptions`) | { key: '__ALL', value: '', label: 'All' } |  |

> Note: The parameter name is `freez` (existing library naming convention), not `freeze`.


### 2.2 Global Registration
```javascript
// Defines global.Enum in Node.js
// Defines window.Enum in browsers
Enum.register();
// Customize the global name via key
Enum.register("JsEnum"); // window.JsEnum
```

### 2.3 Basic Usage
```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: 'Red' },
  { key: 'GREEN', value: 'green', label: 'Green' },
]);
// Access member values
Color.RED // 'red'
Color.GREEN // 'green'
// Member count
Color.length // 2

Color.toJSON(); // Returns array [{"key":"RED","value":"red","label":"Red"},{"key":"GREEN","value":"green","label":"Green"}]
JSON.stringify(Color); // Returns string '[{"key":"RED","value":"red","label":"Red"},{"key":"GREEN","value":"green","label":"Green"}]'

// Get a member
const member = Color.getMember('red'); // Returns member object {"key":"RED","value":"red","label":"Red"}
member.value === 'red'; // true
member.key; // 'RED'
member.label; // 'Red'
Color.getLabel(Color.RED); // 'Red'

// Check if a value is valid
Color.has('red'); // true
Color.has('yellow'); // false

// map, forEach, and filter work directly
Color.map(member => member.label); // ['Red', 'Green']
// Enumerable keys are the member keys
Object.keys(Color); // ['RED', 'GREEN']
// for...in iterates over keys
for (const key in Color) {
  console.log(key);
}
// for...of iterates over member objects
for (const member of Color) {
  console.log(member);
}

// Construct from a plain object
const ColorV2 = new Enum({
  Red: 'red',
  green: 'green',
});
ColorV2.toJSON(); // [{"key":"Red","value":"red"},{"key":"green","value":"green"}]
// Keys are case-sensitive
ColorV2.Red // 'red'
ColorV2.green // 'green'
```

### 2.4 Frontend Component Integration
Example with `React + Ant Design`:
```jsx
import React from 'react';
import { Select, Radio, Table } from 'antd';
// Call Enum.register() in your entry file (e.g. index.js) for global access
import Enum from 'js-enumerate';

const Color = new Enum([
  { key: 'RED', value: 'red', label: 'Red' },
  { key: 'GREEN', value: 'green', label: 'Green' },
]);
// Used in Select, Radio, and Table column filters
const App = () => (
  <>
    {/* filters includes an "All" option by default */}
    <Select defaultValue={Color.RED} options={Color.filters} />
    <Radio.Group defaultValue={Color.GREEN} options={Color.options} />
    {/* toFilters() adapts to Antd Table filters: { text, value } */}
    <Table columns={[{ key: 'color', title: 'Color', filters: Color.toFilters() }]}/>
  </>
);
```

### 2.5 Advanced Usage
```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: 'Red', disabled: true, color: '#f00' },
  { key: 'GREEN', value: 'green', label: 'Green', extra: { msg: 'extra info' }, color: '#0f0' },
]);
const redMem = Color.getMember(Color.RED);
redMem.disabled // true
redMem.color // '#f00'
const greenMem = Color.getMember(Color.GREEN);
greenMem.extra // { msg: 'extra info' }

// Write operations throw errors
Color.RED = 'red-v2'; // Throws Error
delete Color.RED; // Throws Error
redMem.label = 'Dark Red'; // Throws Error

// Disable freezing via options.freez
// Not recommended — may lead to unexpected behavior
const ColorEdit = new Enum([
  { key: 'RED', value: 'red', label: 'Red' },
  { key: 'GREEN', value: 'green', label: 'Green' },
], { freez: false });
const redEdit = ColorEdit.getMember(ColorEdit.RED);
redEdit.label // 'Red'
redEdit.label = 'Dark Red' // true
redEdit.label // 'Dark Red'
```

### 2.6 Built-in Properties
- `length` — Total number of enum members
- `options` — Member list without the "All" option, equivalent to `getOptions({ enableAll: false })`
- `filters` — Member list with the "All" option, equivalent to `getOptions()`

### 2.7 Enum Object API
- `forEach`, `map`, `filter` — Iterate over enum members
- `getMember(value)` — Get a member object by its value
- `has(value)` — Check whether a value exists in the enum
- `getLabel(value)` — Get the label of a member by its value
- `toJSON()` — Return the enum members as an array, compatible with `JSON.stringify()`
- `toFilters(options = {})` — Convert to Ant Design / Element table `filters` format (`{ text, value }`, excludes "All" by default)
- `to_filters(options = {})` — Legacy alias (deprecated, use `toFilters` instead)
- `getOptions(options = {})` — Return member array with customizable keys via `enableAll`/`keyValue`/`keyLabel`/`allDefaultValue`
- `Enum.register(key = 'Enum')` — Static method to register the Enum class globally

### 2.8 Notes
- Member `key` must be a string composed of alphanumeric characters, hyphens, or underscores, and cannot start with `__`.
- Member `key` cannot use reserved property names such as `length`, `options`, or `filters`.
- Member `value` cannot be `null` or `undefined`.
- Member `label` cannot be `null` or `''`. If `label` is omitted, `value` is used as fallback for display.
- Enum instances and their members are frozen (`freez`) by default and cannot be modified.


## 3. Related Projects
- For Python backends, consider using [py-enum](https://github.com/skylerhu/py-enum) alongside this library.
