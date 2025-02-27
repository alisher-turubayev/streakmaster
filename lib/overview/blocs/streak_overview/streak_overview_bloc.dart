import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';
import 'package:data_repository/data_repository.dart';

part 'streak_overview_event.dart';
part 'streak_overview_state.dart';

class StreakOverviewBloc extends Bloc<StreakOverviewEvent, StreakOverviewState> {
  StreakOverviewBloc({
    required DataRepository repository
  })  : _repository = repository,
      super(const StreakOverviewState()) {
    on<StreakDataSubscriptionRequested>(_onSubscriptionRequested);
  }

  final DataRepository _repository;

  Future<void> _onSubscriptionRequested(
    StreakDataSubscriptionRequested event,
    Emitter<StreakOverviewState> emit,
  ) async {
    emit(state.copyWith(status: StreakLoadStatus.loading));

    await emit.forEach<Streak>(
      _repository.getStreak(),
      onData: (streak) => state.copyWith(
        status: StreakLoadStatus.success,
        streak: streak
      ),
      onError: (_, __) => state.copyWith(
        status: StreakLoadStatus.failure,
      )
    );
  }
}