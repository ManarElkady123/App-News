import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/features/news/cubit/news_cubit.dart';
import 'package:flutter_lab16_1/features/news/views/article_detail_screen.dart';
import '../../data/models/article_model.dart';


class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: FutureBuilder<List<Article>>(
        future: context.read<NewsCubit>().getBookmarkedArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookmarks yet'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final article = snapshot.data![index];
              return ListTile(
                leading: article.imageUrl != null 
                    ? Image.network(article.imageUrl!, width: 50)
                    : null,
                title: Text(article.title),
                subtitle: Text(article.source),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: article),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}