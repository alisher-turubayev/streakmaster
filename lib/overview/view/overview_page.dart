import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_meister/overview/overview.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StreakOverviewBloc>(
          create: (context) => StreakOverviewBloc(
            repository: context.read<DataRepository>()
          )..add(const StreakDataSubscriptionRequested()),
        ),
        BlocProvider<GoalsOverviewBloc>(
          create: (context) => GoalsOverviewBloc(
            repository: context.read<DataRepository>()
          )..add(const GoalsDataSubscriptionRequested()),
        ),
      ],
      child: const OverviewView(), 
    );
  }
}

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StreakOverviewBloc, StreakOverviewState>(
          listenWhen: (previous, current) =>
            previous.status != current.status,
          listener: (context, state) {
            if (state.status == StreakLoadStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Failed to retrieve streak data.')
                  ),
                );
            }
          },
        ),
        BlocListener<GoalsOverviewBloc, GoalsOverviewState>(
          listenWhen: (previous, current) => 
            previous.status != current.status,
          listener: (context, state) {
            if (state.status == GoalsLoadStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Failed to retrieve goals data.')
                  ),
                );
            }
          },
        ),
      ],
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<StreakOverviewBloc, StreakOverviewState>(
                builder: (context, state) {
                  if (state.status == StreakLoadStatus.loading) {
                    return const CircularProgressIndicator();
                  } else if (state.status != StreakLoadStatus.success) {
                    return const SizedBox();
                  }
                  // In all other situations we are guaranteed to have a streak 
                  return StreakHeroWidget(days: state.streak!.days);
                },
              ),
              Divider(),
              Text(
                'Goals:',
                style: TextTheme.of(context).titleLarge,
              ),
              BlocBuilder<GoalsOverviewBloc, GoalsOverviewState>(
                builder: (context, state) {
                  if (state.status == GoalsLoadStatus.loading) {
                    return const CircularProgressIndicator();
                  } else if (state.status != GoalsLoadStatus.success) {
                    return const SizedBox();
                  }
                  // Shouldn't need the first check as the previous condition
                  //  takes care of situations (init, fail) where state.goals
                  //  is null
                  if (state.goals == null || state.goals!.isEmpty) {
                    return Text(
                      'No goals added. Add one now!',
                      style: TextTheme.of(context).bodyMedium,
                    );
                  }
                  return ListView.builder(
                      itemBuilder: (context, index) {
                        return GoalsListTile(
                          name: state.goals![index].name,
                          iconDataCodePoint: state.goals![index].iconDataCodePoint,
                          timestampAchieved: state.goals![index].timestampAchieved,
                          onPressed: null,
                        );
                      }
                  );
                },
              )
            ],
          )
        )
      )
    );
  }
}