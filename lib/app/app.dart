import 'package:flutter/material.dart';
import 'package:streak_master/home/home_screen.dart';
import 'package:streak_master/goals/goal_view_screen.dart';
import 'package:streak_master/goals/goals_list_screen.dart';
import 'package:streak_master/settings/settings_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreakMaster',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          title: Text('Healthy Living', style: TextTheme.of(context).titleLarge), // TODO: figure how to make an animated one
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ), // TODO: make responsive to layout changes
        body:  SafeArea(
          child: GoalViewScreen(), 
        ),
        /* bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list_rounded),
              label: 'All Goals'
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'Settings',
            ),
          ], 
        ), */
      ),
    );
  }
}
