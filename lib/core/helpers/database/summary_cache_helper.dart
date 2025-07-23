import 'dart:convert';
import 'package:aura/core/helpers/database/cache_helper.dart';
import 'package:aura/core/di/service_locator.dart';
import '../../../features/summary/data/models/summary_model.dart';

class SummaryPrefs {
  static const String _key = 'summaries';

  static CacheHelper get _cacheHelper => getIt<CacheHelper>();

  static Future<List<Summary>> getSummaries() async {
    final List<String>? jsonList =
        _cacheHelper.getData(key: _key)?.cast<String>();
    if (jsonList == null) return [];
    return jsonList.map((e) => Summary.fromJson(json.decode(e))).toList();
  }

  static Future<void> addSummary(Summary summary) async {
    final List<String> jsonList =
        _cacheHelper.getData(key: _key)?.cast<String>() ?? [];
    jsonList.insert(0, json.encode(summary.toJson()));
    await _cacheHelper.saveData(key: _key, value: jsonList);
  }

  static Future<void> removeSummary(int index) async {
    final List<String> jsonList =
        _cacheHelper.getData(key: _key)?.cast<String>() ?? [];
    if (index >= 0 && index < jsonList.length) {
      jsonList.removeAt(index);
      await _cacheHelper.saveData(key: _key, value: jsonList);
    }
  }

  static Future<void> clearAllSummaries() async {
    await _cacheHelper.removeData(key: _key);
  }
}
