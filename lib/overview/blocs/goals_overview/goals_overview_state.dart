part of 'goals_overview_bloc.dart';

enum GoalsLoadStatus { init, loading, success, failure }

final class GoalsOverviewState extends Equatable {
  const GoalsOverviewState({
    this.status = GoalsLoadStatus.init,
    this.goals
  });

  final GoalsLoadStatus status;
  final List<Goal>? goals;

  GoalsOverviewState copyWith({
    GoalsLoadStatus? status,
    List<Goal>? goals,
  }) => GoalsOverviewState(
    status: status ?? this.status,
    goals: goals ?? this.goals,
  );

  @override
  List<Object?> get props => [status, goals];
}