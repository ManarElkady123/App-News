import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/features/news/cubit/news_state.dart';
import '../cubit/news_cubit.dart';
import '../widgets/article_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NewsCubit>().fetchTopHeadlines();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<NewsCubit>().loadMoreArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<NewsCubit>().fetchTopHeadlines(refresh: true),
          ),
        ],
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  if (state.canRetry)
                    ElevatedButton(
                      onPressed: () => context.read<NewsCubit>().fetchTopHeadlines(),
                      child: const Text('Retry'),
                    ),
                ],
              ),
            );
          } else if (state is NewsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NewsCubit>().fetchTopHeadlines(refresh: true);
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.articles.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.articles.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ArticleCard(article: state.articles[index]);
                },
              ),
            );
          } else if (state is NewsEmpty) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}