# js-enumerate

[中文文档](README.zh.md) | **English**

[![NPM Version](https://img.shields.io/npm/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![NPM Downloads](https://img.shields.io/npm/dm/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Bundle Size](https://img.shields.io/bundlephobia/minzip/js-enumerate)](https://bundlephobia.com/package/js-enumerate)
[![Node Version](https://img.shields.io/node/v/js-enumerate)](https://www.npmjs.com/package/js-enumerate)
[![Test](https://github.com/skylerhu/js-enum/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/skylerhu/js-enum/actions/workflows/test.yml)
[![Codecov](https://codecov.io/gh/skylerhu/js-enum/graph/badge.svg)](https://codecov.io/gh/skylerhu/js-enum)
[![License](https://img.shields.io/github/license/skylerhu/js-enum)](https://github.com/skylerhu/js-enum/blob/master/LICENSE)

A JavaScript enum utility for **Node.js** and **browsers**. Build type-safe, immutable Enum instances from arrays or objects — with built-in validation, iteration, and frontend-friendly data transformations for selects, radios, checkboxes, and table filters.

## Features

- Build enums from **arrays** or **plain objects**
- Members are **frozen by default** (immutable)
- Built-in `has()`, `getMember()`, `getLabel()` for validation and lookup
- Iterable — supports `for...of`, `map`, `forEach`, `filter`
- Frontend-ready `options` / `filters` / `toFilters()` for Ant Design, Element UI, etc.
- Global registration via `Enum.register()`
- Works in Node.js (CommonJS) and browsers (UMD)

## Installation

```bash
npm install js-enumerate
```

For browser usage, include the UMD bundle directly:

```html
<script src="releases/js-enumerate-latest.min.js"></script>
```

> You can upload [releases/js-enumerate-latest.min.js](./releases/js-enumerate-latest.min.js) to your CDN or copy it into your project.

## Quick Start

```javascript
import Enum from 'js-enumerate';

const Color = new Enum([
  { key: 'RED', value: 'red', label: 'Red' },
  { key: 'GREEN', value: 'green', label: 'Green' },
]);

Color.RED           // 'red'
Color.GREEN         // 'green'
Color.length        // 2
Color.has('red')    // true
Color.getLabel('red') // 'Red'

// Iterate
Color.map(m => m.label); // ['Red', 'Green']

// Construct from a plain object
const Status = new Enum({ Active: 1, Inactive: 0 });
Status.Active  // 1
```

## Usage

### Constructor

```javascript
new Enum(data, options)
```

| Parameter | Type | Description | Default |
| --- | --- | --- | --- |
| data | array / object | Enum members | — |
| options | object | Configuration | — |

**Options:**

| Parameter | Type | Description | Default |
| --- | --- | --- | --- |
| freez | boolean | Freeze the instance and members (immutable) | `true` |
| allDefaultValue | object | Default "All" option for `filters` / `getOptions` | `{ key: '__ALL', value: '', label: 'All' }` |

> The parameter name is `freez` (existing library convention), not `freeze`.

### Global Registration

```javascript
Enum.register();       // global.Enum (Node.js) / window.Enum (browser)
Enum.register('JsEnum'); // window.JsEnum
```

### Frontend Component Integration

Example with **React + Ant Design**:

```jsx
import Enum from 'js-enumerate';
import { Select, Radio, Table } from 'antd';

const Color = new Enum([
  { key: 'RED', value: 'red', label: 'Red' },
  { key: 'GREEN', value: 'green', label: 'Green' },
]);

const App = () => (
  <>
    <Select defaultValue={Color.RED} options={Color.filters} />
    <Radio.Group defaultValue={Color.GREEN} options={Color.options} />
    <Table columns={[{ key: 'color', title: 'Color', filters: Color.toFilters() }]} />
  </>
);
```

### Advanced Usage

```javascript
const Color = new Enum([
  { key: 'RED', value: 'red', label: 'Red', disabled: true, color: '#f00' },
  { key: 'GREEN', value: 'green', label: 'Green', extra: { msg: 'info' }, color: '#0f0' },
]);

Color.getMember('red').disabled // true
Color.getMember('green').extra  // { msg: 'info' }

// Frozen by default — write operations throw
Color.RED = 'new'; // Throws Error

// Opt out of freezing (not recommended)
const Mutable = new Enum([
  { key: 'A', value: 1, label: 'Alpha' },
], { freez: false });
```

## API Reference

### Properties

| Property | Description |
| --- | --- |
| `length` | Total number of enum members |
| `options` | Member list without "All", equivalent to `getOptions({ enableAll: false })` |
| `filters` | Member list with "All", equivalent to `getOptions()` |

### Methods

| Method | Description |
| --- | --- |
| `has(value)` | Check whether a value exists in the enum |
| `getMember(value)` | Get a member object by its value |
| `getLabel(value)` | Get the label of a member by its value |
| `forEach(fn)` | Iterate over members |
| `map(fn)` | Map over members and return an array |
| `filter(fn)` | Filter members and return an array |
| `toJSON()` | Return members as an array, compatible with `JSON.stringify()` |
| `toFilters(options?)` | Convert to Ant Design / Element table filters (`{ text, value }`, excludes "All") |
| `getOptions(options?)` | Return member array with customizable keys via `enableAll` / `keyValue` / `keyLabel` / `allDefaultValue` |
| `Enum.register(key?)` | Static method — register Enum globally (default key: `'Enum'`) |

> `to_filters()` is a deprecated alias for `toFilters()` and will be removed in a future release.

## Notes

- Member `key` must be alphanumeric (plus `-` and `_`) and cannot start with `__`.
- Member `key` cannot use reserved names: `length`, `options`, `filters`.
- Member `value` cannot be `null` or `undefined`.
- Member `label` cannot be `null` or `''`. If omitted, `value` is used as fallback.
- Instances are frozen by default (`freez: true`).

## Contributing

See [CONTRIBUTING.md](./docs/CONTRIBUTING.md) for development setup and guidelines.

## Changelog

See [CHANGELOG](./docs/CHANGELOG-1.x.md) for version history.

## License

[MIT](./LICENSE)

## Related Projects

- [py-enum](https://github.com/skylerhu/py-enum) — Python enum utility with a similar API, great for full-stack consistency.
