import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? content;
  final String? imageUrl;
  final DateTime publishedAt;
  final String source;
  final String? author;
  final String url;
  final String? category;
  bool isBookmarked;

  Article({
    required this.id,
    required this.title,
    required this.description,
    this.content,
    this.imageUrl,
    required this.publishedAt,
    required this.source,
    this.author,
    required this.url,
    this.category,
    this.isBookmarked = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['source']['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: json['title'] ?? 'No title',
        description: json['description'] ?? 'No description',
        content: json['content'],
        imageUrl: json['urlToImage'],
        publishedAt: DateTime.parse(json['publishedAt']),
        source: json['source']['name'] ?? 'Unknown',
        author: json['author'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'source': {'id': id, 'name': source},
        'title': title,
        'description': description,
        'content': content,
        'urlToImage': imageUrl,
        'publishedAt': publishedAt.toIso8601String(),
        'author': author,
        'url': url,
        'isBookmarked': isBookmarked,
      };

  Article copyWith({
    bool? isBookmarked,
  }) {
    return Article(
      id: id,
      title: title,
      description: description,
      content: content,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      source: source,
      author: author,
      url: url,
      category: category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        isBookmarked,
      ];
}