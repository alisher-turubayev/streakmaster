part of 'streak_overview_bloc.dart';

enum StreakLoadStatus { init, loading, success, failure }

final class StreakOverviewState extends Equatable {
  const StreakOverviewState({
    this.status = StreakLoadStatus.init,
    this.streak
  });

  final StreakLoadStatus status;
  final Streak? streak;

  @override
  List<Object?> get props => [status, streak];

  StreakOverviewState copyWith({
    StreakLoadStatus? status,
    Streak? streak,
  }) => StreakOverviewState(
    status: status ?? this.status,
    streak: streak ?? this.streak
  );
}