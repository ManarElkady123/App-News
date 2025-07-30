import 'package:flutter_lab16_1/data/models/article_model.dart';
import '../../../services/news_service.dart';

class NewsRemoteDataSource {
  final NewsService newsService;

  NewsRemoteDataSource(this.newsService);

  Future<List<Article>> getTopHeadlines({
    String country = 'us',
    String? category,
    int page = 1,
  }) async {
    final response = await newsService.getTopHeadlines(
      country: country,
      category: category,
      page: page,
    );
    return (response['articles'] as List)
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();
  }
}