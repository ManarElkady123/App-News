// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_lab16_1/repositores/news_repository.dart';
// import '../../../data/models/article_model.dart';
// import 'news_state.dart';

// class NewsCubit extends Cubit<NewsState> {
//   final NewsRepository newsRepository;
//   int _page = 1;
//   bool _hasMore = true;

//   NewsCubit(this.newsRepository) : super(NewsInitial());

//   Future<void> fetchTopHeadlines({bool refresh = false}) async {
//     if (refresh) {
//       _page = 1;
//       _hasMore = true;
//       emit(NewsRefreshing());
//     } else if (_page == 1) {
//       emit(NewsLoading());
//     }

//     try {
//       final articles = await newsRepository.getTopHeadlines(
//         refresh: refresh,
//         page: _page,
//       );
      
//       if (articles.isEmpty) {
//         emit(NewsEmpty('No articles found'));
//       } else {
//         emit(NewsLoaded(articles, hasMore: _hasMore));
//       }
//     } catch (e) {
//       emit(NewsError(e.toString(), canRetry: _page == 1));
//     }
//   }

//   Future<void> loadMoreArticles() async {
//     if (!_hasMore) return;
    
//     final currentState = state;
//     if (currentState is! NewsLoaded) return;
    
//     _page++;
//     try {
//       final newArticles = await newsRepository.getTopHeadlines(page: _page);
      
//       if (newArticles.isEmpty) {
//         _hasMore = false;
//         emit(currentState.copyWith(hasMore: false));
//       } else {
//         emit(currentState.copyWith(
//           articles: [...currentState.articles, ...newArticles],
//           hasMore: _hasMore,
//         ));
//       }
//     } catch (e) {
//       _page--;
//       emit(currentState.copyWith(hasMore: false));
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/repositores/news_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/article_model.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository newsRepository;
  final SharedPreferences sharedPreferences;
  int _page = 1;
  bool _hasMore = true;
  static const String _bookmarksKey = 'BOOKMARKED_ARTICLES';

  NewsCubit({
    required this.newsRepository,
    required this.sharedPreferences,
  }) : super(NewsInitial()) {
    _loadInitialBookmarks();
  }

  Future<void> _loadInitialBookmarks() async {
    try {
      final bookmarksJson = sharedPreferences.getString(_bookmarksKey);
      if (bookmarksJson != null) {
        final List<dynamic> jsonList = json.decode(bookmarksJson);
        final bookmarks = jsonList.map((json) => Article.fromJson(json)).toList();
        
        if (state is NewsLoaded) {
          final currentState = state as NewsLoaded;
          final updatedArticles = currentState.articles.map((article) {
            final bookmarked = bookmarks.any((b) => b.id == article.id);
            return article.copyWith(isBookmarked: bookmarked);
          }).toList();
          
          emit(currentState.copyWith(articles: updatedArticles));
        }
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }

  void toggleBookmark(Article article) {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      final updatedArticles = currentState.articles.map((a) {
        return a.id == article.id ? article : a;
      }).toList();
      
      emit(currentState.copyWith(articles: updatedArticles));
      _saveBookmark(article);
    }
  }

  Future<void> _saveBookmark(Article article) async {
    try {
      final bookmarksJson = sharedPreferences.getString(_bookmarksKey);
      final List<Article> bookmarks = bookmarksJson != null
          ? (json.decode(bookmarksJson) as List)
              .map((json) => Article.fromJson(json))
              .toList()
          : [];

      if (article.isBookmarked) {
        // Add or update bookmark
        if (!bookmarks.any((b) => b.id == article.id)) {
          bookmarks.add(article);
        }
      } else {
        // Remove bookmark
        bookmarks.removeWhere((b) => b.id == article.id);
      }

      await sharedPreferences.setString(
        _bookmarksKey,
        json.encode(bookmarks.map((a) => a.toJson()).toList()),
      );
    } catch (e) {
      print('Error saving bookmark: $e');
    }
  }

  Future<List<Article>> getBookmarkedArticles() async {
    try {
      final bookmarksJson = sharedPreferences.getString(_bookmarksKey);
      if (bookmarksJson != null) {
        return (json.decode(bookmarksJson) as List)
            .map((json) => Article.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error getting bookmarks: $e');
    }
    return [];
  }

  // ... [keep all your existing methods like fetchTopHeadlines, loadMoreArticles] ...
 

  Future<void> fetchTopHeadlines({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      emit(NewsRefreshing());
    } else if (_page == 1) {
      emit(NewsLoading());
    }

    try {
      final articles = await newsRepository.getTopHeadlines(
        refresh: refresh,
        page: _page,
      );
      
      if (articles.isEmpty) {
        emit(NewsEmpty('No articles found'));
      } else {
        emit(NewsLoaded(articles, hasMore: _hasMore));
      }
    } catch (e) {
      emit(NewsError(e.toString(), canRetry: _page == 1));
    }
  }

  Future<void> loadMoreArticles() async {
    if (!_hasMore) return;
    
    final currentState = state;
    if (currentState is! NewsLoaded) return;
    
    _page++;
    try {
      final newArticles = await newsRepository.getTopHeadlines(page: _page);
      
      if (newArticles.isEmpty) {
        _hasMore = false;
        emit(currentState.copyWith(hasMore: false));
      } else {
        emit(currentState.copyWith(
          articles: [...currentState.articles, ...newArticles],
          hasMore: _hasMore,
        ));
      }
    } catch (e) {
      _page--;
      emit(currentState.copyWith(hasMore: false));
    }
  }
}