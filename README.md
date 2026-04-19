# dart_vika / 维格表国际化工具

[![Pub Version](https://img.shields.io/badge/pub-v0.0.1-blue)](https://pub.dev/packages/dart_vika)
[![GitHub](https://img.shields.io/badge/GitHub-ValueNotify666%2Fdart__vika-green)](https://github.com/ValueNotify666/dart_vika)

[English](#english) | [中文](#中文)

---

## 中文 / Chinese

### 简介

`dart_vika` 是一个 Dart 包，用于从维格表 (Vika) API 获取国际化 (i18n) 翻译数据。它支持自动节流控制，避免超过 API 限制，并将维格表数据转换为适合 Flutter 应用使用的 JSON 格式。

### 功能特性

- 🔑 **简单初始化** - 只需 API Key 即可开始使用
- 🌐 **多版本支持** - 支持 V1 和 V3 API 版本
- ⏱️ **智能节流** - 1 秒请求间隔，避免超过 Vika API 限制 (1秒5次)
- 🔄 **自动转换** - 将维格表字段自动转换为 i18n JSON 格式
- 🛡️ **错误处理** - 完善的异常处理和错误提示

### 安装

```yaml
dependencies:
  dart_vika: ^0.0.1
```

### 快速开始

```dart
import 'package:dart_vika/dart_vika.dart';

void main() async {
  // 初始化 / Initialize
  DartVika.init('your-api-key');
  
  // 获取翻译数据 / Get translations
  final translations = await DartVika.get('your-datasheet-id');
  
  print(translations);
  // 输出 / Output:
  // {
  //   "app_zh_cn": {
  //     "appname": "Nice Player",
  //     "today": "今天是{year}年{month}月{day}日"
  //   },
  //   "app_en": {
  //     "appname": "Nice Player",
  //     "today": "Today is {month}/{day}/{year}"
  //   }
  // }
}
```

### API 文档

#### `DartVika.init(String apiKey, {bool isV3 = false})`

初始化 DartVika 客户端。

- `apiKey`: 维格表 API Token（不能为空）
- `isV3`: 是否使用 V3 API，默认为 false (V1)

#### `DartVika.get(String datasheetId)`

获取并转换翻译数据。

- `datasheetId`: 维格表 ID（为空时返回 null）
- 返回: `Map<String, dynamic>?` 格式的翻译数据

### 数据格式要求

维格表需要包含以下字段：
- `Key[code=key]`: 翻译键名
- `XXX[code=locale_code]`: 各语言翻译，如 `CHN[code=app_zh_cn]`

---

## English

### Introduction

`dart_vika` is a Dart package for fetching internationalization (i18n) translation data from Vika API. It features automatic throttling to avoid API limits and transforms Vika data into JSON format suitable for Flutter apps.

### Features

- 🔑 **Simple Initialization** - Get started with just an API Key
- 🌐 **Multi-version Support** - Supports both V1 and V3 API versions
- ⏱️ **Smart Throttling** - 1 second request interval to avoid Vika API limits (5 req/s)
- 🔄 **Auto Transformation** - Automatically transforms Vika fields to i18n JSON format
- 🛡️ **Error Handling** - Comprehensive exception handling and error messages

### Installation

```yaml
dependencies:
  dart_vika: ^0.0.1
```

### Quick Start

```dart
import 'package:dart_vika/dart_vika.dart';

void main() async {
  // Initialize
  DartVika.init('your-api-key');
  
  // Get translations
  final translations = await DartVika.get('your-datasheet-id');
  
  print(translations);
  // Output:
  // {
  //   "app_zh_cn": {
  //     "appname": "Nice Player",
  //     "today": "Today is {month}/{day}/{year}"
  //   },
  //   "app_en": {
  //     "appname": "Nice Player",
  //     "today": "Today is {month}/{day}/{year}"
  //   }
  // }
}
```

### API Reference

#### `DartVika.init(String apiKey, {bool isV3 = false})`

Initialize the DartVika client.

- `apiKey`: Vika API Token (cannot be empty)
- `isV3`: Whether to use V3 API, default is false (V1)

#### `DartVika.get(String datasheetId)`

Fetch and transform translation data.

- `datasheetId`: Vika datasheet ID (returns null if empty)
- Returns: `Map<String, dynamic>?` formatted translation data

### Data Format Requirements

Your Vika datasheet should contain:
- `Key[code=key]`: Translation key name
- `XXX[code=locale_code]`: Translations for each locale, e.g., `CHN[code=app_zh_cn]`

---

## 更多信息 / More Information

- **GitHub**: https://github.com/ValueNotify666/dart_vika
- **Issues**: https://github.com/ValueNotify666/dart_vika/issues
- **Vika API 文档 / Docs**: https://developers.vika.cn/api/introduction/

## License

MIT License
