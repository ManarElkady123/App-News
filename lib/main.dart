import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/repositores/news_repository.dart';
import 'package:flutter_lab16_1/sources/local/news_local_data_source.dart';
import 'package:flutter_lab16_1/sources/remote/news_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/news/cubit/news_cubit.dart';
import 'features/news/views/home_screen.dart';
import 'services/news_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sharedPrefs = await SharedPreferences.getInstance();
  final newsService = NewsService();
  
  runApp(MyApp(
    
    newsRepository: NewsRepository(
      remoteDataSource: NewsRemoteDataSource(newsService),
      localDataSource: NewsLocalDataSource(sharedPrefs),
    ),
    sharedPreferences: sharedPrefs,
  ));
}

class MyApp extends StatelessWidget {
  final NewsRepository newsRepository;
  final SharedPreferences sharedPreferences;

  const MyApp({
    super.key,
    required this.newsRepository,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: BlocProvider(
        create: (context) => NewsCubit(
          newsRepository: newsRepository,
          sharedPreferences: sharedPreferences,
        ),
        child: const HomeScreen(),
      ),
    );
  }
}