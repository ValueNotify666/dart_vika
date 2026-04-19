import 'dart:convert';
import 'package:http/http.dart' as http;

/// 当 API Key 未提供时抛出的异常 / Exception thrown when API key is not provided
class VikaApiKeyException implements Exception {
  final String message;
  VikaApiKeyException(this.message);

  @override
  String toString() => 'VikaApiKeyException: $message';
}

/// DartVika - 维格表 API 客户端，用于获取国际化翻译数据
/// DartVika is a client for Vika API to fetch i18n translations.
class DartVika {
  static String? _apiKey;
  static bool _isV3 = false;
  static DateTime? _lastRequestTime;

  /// 初始化 DartVika，设置 API Key 和 API 版本
  /// Initialize DartVika with API key and API version.
  /// 
  /// [apiKey] - 维格表 API Token / Your Vika API Token. If empty, throws exception.
  /// [isV3] - 是否使用 V3 API，默认为 false (使用 V1) / Whether to use V3 API. Default is false (V1).
  static void init(String apiKey, {bool isV3 = false}) {
    if (apiKey.isEmpty) {
      throw VikaApiKeyException(
        '访问 https://developers.vika.cn/api/introduction/ 以获取如何获取 API Key。\n'
        'Visit https://developers.vika.cn/api/introduction/ to learn how to get your API Key.'
      );
    }
    _apiKey = apiKey;
    _isV3 = isV3;
  }

  /// 获取基础 URL (根据 API 版本)
  /// Get base URL based on API version.
  static String get _baseUrl {
    return _isV3
        ? 'https://api.vika.cn/fusion/v3/'
        : 'https://api.vika.cn/fusion/v1/';
  }

  /// 从维格表获取记录并返回格式化的国际化数据
  /// Fetch records from Vika datasheet and return formatted i18n data.
  /// 
  /// [datasheetId] - 维格表 ID / The ID of the Vika datasheet.
  /// 返回以语言代码为键、翻译映射为值的 Map / Returns a Map with locale codes as keys and translation maps as values.
  /// 如果 datasheetId 为空则返回 null / Returns null if datasheetId is empty.
  static Future<Map<String, dynamic>?> get(String datasheetId) async {
    if (datasheetId.isEmpty) {
      return null;
    }

    if (_apiKey == null || _apiKey!.isEmpty) {
      throw VikaApiKeyException(
        'DartVika not initialized. Call DartVika.init(apiKey) first.'
      );
    }

    // 节流控制：请求间隔 1 秒 (Vika API 限制 1 秒 5 次请求)
    // Throttle: 1 second between requests (Vika API limit: 5 requests per second)
    if (_lastRequestTime != null) {
      final elapsed = DateTime.now().difference(_lastRequestTime!);
      if (elapsed < const Duration(seconds: 1)) {
        await Future.delayed(const Duration(seconds: 1) - elapsed);
      }
    }
    _lastRequestTime = DateTime.now();

    final url = Uri.parse('${_baseUrl}datasheets/$datasheetId/records');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch records: ${response.statusCode} - ${response.body}');
    }

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    return _transformRecords(jsonData);
  }

  /// 将维格表 API 响应转换为国际化格式
  /// Transform Vika API response into i18n format.
  /// 
  /// Input format:
  /// {
  ///   "data": {
  ///     "records": [
  ///       {
  ///         "fields": {
  ///           "Key[code=key]": "appname",
  ///           "CHN[code=app_zh_cn]": "Nice Player",
  ///           "Chinese[code=app_zh]": "Nice Player",
  ///           "English[code=app_en]": "Nice Player"
  ///         }
  ///       }
  ///     ]
  ///   }
  /// }
  /// 
  /// Output format:
  /// {
  ///   "app_zh_cn": {
  ///     "appname": "Nice Player"
  ///   },
  ///   "app_zh": {
  ///     "appname": "Nice Player"
  ///   },
  ///   "app_en": {
  ///     "appname": "Nice Player"
  ///   }
  /// }
  static Map<String, dynamic> _transformRecords(Map<String, dynamic> data) {
    final result = <String, Map<String, dynamic>>{};
    
    final records = data['data']?['records'] as List<dynamic>?;
    if (records == null) {
      return result;
    }

    for (final record in records) {
      final fields = record['fields'] as Map<String, dynamic>?;
      if (fields == null) continue;

      // Extract key from "Key[code=key]" field
      final key = fields['Key[code=key]'] as String?;
      if (key == null) continue;

      // Process each field to extract locale code and translation
      for (final entry in fields.entries) {
        final fieldName = entry.key;
        final value = entry.value;

        // Skip the key field itself
        if (fieldName == 'Key[code=key]') continue;

        // Extract locale code from field name like "CHN[code=app_zh_cn]"
        final localeCode = _extractLocaleCode(fieldName);
        if (localeCode == null) continue;

        // Initialize locale map if not exists
        result.putIfAbsent(localeCode, () => {});
        
        // Add translation
        result[localeCode]![key] = value;
      }
    }

    return result;
  }

  /// 从字段名中提取语言代码
  /// Extract locale code from field name.
  /// 
  /// 示例 / Example: "CHN[code=app_zh_cn]" -> "app_zh_cn"
  /// 示例 / Example: "English[code=app_en]" -> "app_en"
  static String? _extractLocaleCode(String fieldName) {
    // Match pattern: anything[code=LOCALE_CODE]
    final regExp = RegExp(r'\[code=([^\]]+)\]');
    final match = regExp.firstMatch(fieldName);
    return match?.group(1);
  }
}
