import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';

class NewsService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<Map<String, dynamic>> getTopHeadlines({
    String country = 'us',
    String? category,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.topHeadlines,
        queryParameters: {
          'country': country,
          'category': category,
          'page': page,
          'apiKey': ApiConstants.apiKey,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 401:
          return 'Invalid API key';
        case 429:
          return 'Rate limit exceeded';
        case 500:
          return 'Server error';
        default:
          return 'Failed to load news';
      }
    }
    return 'Check your internet connection';
  }
}