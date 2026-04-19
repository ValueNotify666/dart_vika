## 0.0.1 / 初始版本 Initial Release

### 功能特性 / Features

- **初始化 / Initialization**: 支持 API Key 和 V3 API 版本配置 / Support API Key and V3 API version configuration
- **数据获取 / Data Fetching**: 从维格表获取国际化翻译数据 / Fetch i18n translation data from Vika datasheet
- **节流控制 / Throttling**: 1 秒请求间隔，避免超过 Vika API 限制 (1秒5次) / 1 second request interval to avoid exceeding Vika API limit (5 req/s)
- **数据转换 / Data Transformation**: 自动将维格表字段转换为 i18n JSON 格式 / Automatically transform Vika fields to i18n JSON format

### API 说明 / API Reference

- `DartVika.init(apiKey, {isV3})` - 初始化客户端 / Initialize the client
- `DartVika.get(datasheetId)` - 获取并转换翻译数据 / Fetch and transform translation data

### 注意 / Notes

- API Key 不能为空 / API Key cannot be empty
- datasheetId 为空时返回 null / Returns null when datasheetId is empty
- 自动处理 `[code=xxx]` 格式的字段名 / Auto-process field names in `[code=xxx]` format
