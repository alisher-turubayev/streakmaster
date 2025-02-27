part of 'streak_overview_bloc.dart';

sealed class StreakOverviewEvent extends Equatable {
  const StreakOverviewEvent();
  
  @override
  List<Object> get props => [];
}

final class StreakDataSubscriptionRequested extends StreakOverviewEvent {
  const StreakDataSubscriptionRequested();
}
