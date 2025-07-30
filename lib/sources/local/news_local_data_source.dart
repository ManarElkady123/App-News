import 'dart:convert';
import 'package:flutter_lab16_1/data/models/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cachedArticlesKey = 'CACHED_ARTICLES';
  static const String _cacheTimestampKey = 'CACHE_TIMESTAMP';
  static const Duration _cacheDuration = Duration(minutes: 30);

  NewsLocalDataSource(this.sharedPreferences);

  Future<List<Article>> getCachedArticles() async {
    final jsonString = sharedPreferences.getString(_cachedArticlesKey);
    if (jsonString == null) return [];

    final timestamp = sharedPreferences.getInt(_cacheTimestampKey);
    if (timestamp != null) {
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheDuration) {
        return [];
      }
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Article.fromJson(json)).toList();
  }

  Future<void> cacheArticles(List<Article> articles) async {
    final jsonList = articles.map((article) => article.toJson()).toList();
    await sharedPreferences.setString(
      _cachedArticlesKey,
      json.encode(jsonList),
    );
    await sharedPreferences.setInt(
      _cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> clearCache() async {
    await sharedPreferences.remove(_cachedArticlesKey);
    await sharedPreferences.remove(_cacheTimestampKey);
  }
}