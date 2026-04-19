import 'dart:async';
import 'package:dart_vika/dart_vika.dart';

/// 测试节流功能 / Test throttling functionality
/// Vika API 限制：1秒最多5次请求 / Vika API limit: max 5 requests per second
/// 我们的节流：1秒间隔 / Our throttle: 1 second interval
Future<void> testThrottling() async {
  const datasheetId = '';
  
  print('=== 开始节流测试 / Starting throttling test ===');
  print('API 限制: 1秒5次 / API limit: 5 requests per second');
  print('我们节流: 1秒间隔 / Our throttle: 1 second interval\n');
  
  final stopwatch = Stopwatch()..start();
  final results = <int>[];
  
  // 1秒内发起100次请求 / Send 100 requests within 1 second
  for (int i = 0; i < 100; i++) {
    final requestStopwatch = Stopwatch()..start();
    
    try {
      final result = await DartVika.get(datasheetId);
      requestStopwatch.stop();
      results.add(requestStopwatch.elapsedMilliseconds);
      
      if (i % 10 == 0) {
        print('请求 #$i 完成，耗时: ${requestStopwatch.elapsedMilliseconds}ms / '
              'Request #$i completed, took: ${requestStopwatch.elapsedMilliseconds}ms');
      }
    } catch (e) {
      print('请求 #$i 失败 / Request #$i failed: $e');
    }
  }
  
  stopwatch.stop();
  
  print('\n=== 节流测试结果 / Throttling Test Results ===');
  print('总耗时 / Total time: ${stopwatch.elapsedMilliseconds}ms (${stopwatch.elapsedMilliseconds / 1000}s)');
  print('请求次数 / Total requests: ${results.length}');
  print('平均每次请求耗时 / Average request time: ${results.reduce((a, b) => a + b) / results.length}ms');
  print('预期耗时(有节流) / Expected time (with throttle): ~100秒 / ~100 seconds');
  print('结论 / Conclusion: 如果总耗时 > 100秒，则节流成功 / If total time > 100s, throttling works');
}

/// 测试数据转换 / Test data transformation
Future<void> testDataTransformation() async {
  const datasheetId = 'dstJyGBdcT73Gp0iw8';
  
  print('\n=== 数据转换测试 / Data Transformation Test ===');
  
  final stopwatch = Stopwatch()..start();
  final result = await DartVika.get(datasheetId);
  stopwatch.stop();
  
  if (result == null) {
    print('获取数据失败 / Failed to get data');
    return;
  }
  
  print('获取数据耗时 / Time to fetch: ${stopwatch.elapsedMilliseconds}ms');
  print('\n转换后的数据结构 / Transformed data structure:');
  print('{');
  
  for (final locale in result.entries) {
    print('  "${locale.key}": {');
    final translations = locale.value as Map<String, dynamic>;
    for (final entry in translations.entries.take(5)) {
      print('    "${entry.key}": "${entry.value}"');
    }
    if (translations.length > 5) {
      print('    ... 还有 ${translations.length - 5} 个键值对 / ... ${translations.length - 5} more entries');
    }
    print('  }');
  }
  
  print('}');
  
  print('\n统计信息 / Statistics:');
  print('- 语言数量 / Locale count: ${result.length}');
  for (final locale in result.entries) {
    final count = (locale.value as Map<String, dynamic>).length;
    print('  - ${locale.key}: $count 个翻译 / $count translations');
  }
}

void main() async {
  // 初始化 DartVika / Initialize DartVika
  const apiKey = '';
  
  print('初始化 DartVika... / Initializing DartVika...');
  DartVika.init(apiKey);
  print('初始化完成 / Initialization completed\n');
  
  // 测试数据转换 / Test data transformation
  await testDataTransformation();
  
  // 测试节流功能（只测试10次，避免等待太久）/ Test throttling (only 10 requests to avoid long wait)
  print('\n=== 节流功能快速测试 / Quick Throttling Test (10 requests) ===');
  const datasheetId = 'dstJyGBdcT73Gp0iw8';
  
  final stopwatch = Stopwatch()..start();
  for (int i = 0; i < 10; i++) {
    final start = DateTime.now();
    await DartVika.get(datasheetId);
    final elapsed = DateTime.now().difference(start).inMilliseconds;
    print('请求 #$i: ${elapsed}ms / Request #$i: ${elapsed}ms');
  }
  stopwatch.stop();
  
  print('\n10次请求总耗时 / Total time for 10 requests: ${stopwatch.elapsedMilliseconds}ms');
  print('预期: > 9000ms (因为每次请求间隔1秒) / Expected: > 9000ms (1s interval between requests)');
  
  if (stopwatch.elapsedMilliseconds > 9000) {
    print('✅ 节流功能正常 / Throttling is working correctly');
  } else {
    print('⚠️ 节流功能可能异常 / Throttling might not be working');
  }
}
