import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:streak_meister/home/home.dart';

class App extends StatelessWidget {
  const App({
    required this.repository,
    super.key,
  });

  final DataRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreakMaster',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: RepositoryProvider.value(
        value: repository,
        child: HomePage(),
      ),
    );
  }
}
