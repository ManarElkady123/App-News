import 'package:equatable/equatable.dart';
import '../../../data/models/article_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsRefreshing extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool hasMore;

  const NewsLoaded(this.articles, {this.hasMore = true});

  NewsLoaded copyWith({
    List<Article>? articles,
    bool? hasMore,
  }) {
    return NewsLoaded(
      articles ?? this.articles,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object> get props => [articles, hasMore];
}

class NewsError extends NewsState {
  final String message;
  final bool canRetry;

  const NewsError(this.message, {this.canRetry = true});

  @override
  List<Object> get props => [message, canRetry];
}

class NewsEmpty extends NewsState {
  final String message;

  const NewsEmpty(this.message);

  @override
  List<Object> get props => [message];
  
}