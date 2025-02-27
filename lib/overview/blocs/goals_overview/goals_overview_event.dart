part of 'goals_overview_bloc.dart';

sealed class GoalsOverviewEvent extends Equatable {
  const GoalsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class GoalsDataSubscriptionRequested extends GoalsOverviewEvent {
  const GoalsDataSubscriptionRequested();
}