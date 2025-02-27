import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_meister/goals/goals.dart';
import 'package:streak_meister/home/home.dart';
import 'package:streak_meister/overview/overview.dart';
import 'package:streak_meister/settings/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentTab.index,
          children: [
            GoalsListPage(),
            OverviewPage(),
            SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        currentIndex: currentTab.index,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_rounded),
            label: 'All Goals'
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'Settings',
          ),
        ], 
        onTap: (index) => context.read<HomeCubit>().setTab(HomeTab.values[index]),
      ),
    );
  }
}