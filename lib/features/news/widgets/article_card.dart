import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/data/models/article_model.dart';
import 'package:flutter_lab16_1/features/news/views/article_detail_screen.dart';
import '../cubit/news_cubit.dart';


class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => _openArticle(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              Image.network(
                article.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.source,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      IconButton(
                        icon: Icon(
                          article.isBookmarked 
                              ? Icons.bookmark 
                              : Icons.bookmark_border,
                          color: article.isBookmarked ? Colors.blue : null,
                        ),
                        onPressed: () => _toggleBookmark(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openArticle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  void _toggleBookmark(BuildContext context) {
    final newsCubit = context.read<NewsCubit>();
    final updatedArticle = article.copyWith(
      isBookmarked: !article.isBookmarked,
    );
    newsCubit.toggleBookmark(updatedArticle);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updatedArticle.isBookmarked 
            ? 'Article bookmarked' 
            : 'Bookmark removed',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}