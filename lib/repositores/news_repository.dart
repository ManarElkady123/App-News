import 'package:flutter_lab16_1/data/models/article_model.dart';
import '../sources/remote/news_remote_data_source.dart';
import '../sources/local/news_local_data_source.dart';

class NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<Article>> getTopHeadlines({
    String country = 'us',
    String? category,
    bool refresh = false,
    int page = 1,
  }) async {
    try {
      if (!refresh && page == 1) {
        final cachedArticles = await localDataSource.getCachedArticles();
        if (cachedArticles.isNotEmpty) {
          return cachedArticles;
        }
      }

      final articles = await remoteDataSource.getTopHeadlines(
        country: country,
        category: category,
        page: page,
      );

      if (page == 1) {
        await localDataSource.cacheArticles(articles);
      }

      return articles;
    } catch (e) {
      if (page == 1) {
        final cachedArticles = await localDataSource.getCachedArticles();
        if (cachedArticles.isNotEmpty) return cachedArticles;
      }
      rethrow;
    }
  }
}