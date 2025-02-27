import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';
import 'package:data_repository/data_repository.dart';

part 'goals_overview_event.dart';
part 'goals_overview_state.dart';

class GoalsOverviewBloc extends Bloc<GoalsOverviewEvent, GoalsOverviewState>{
  GoalsOverviewBloc({
    required DataRepository repository,
  })  : _repository = repository,
      super(const GoalsOverviewState()) {
    on<GoalsDataSubscriptionRequested>(_goalsDataSubscriptionRequested);
  }

  final DataRepository _repository;

  Future<void> _goalsDataSubscriptionRequested(
    GoalsDataSubscriptionRequested event,
    Emitter<GoalsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: GoalsLoadStatus.loading));
    await emit.forEach<List<Goal>>(
      _repository.getGoals(),
      onData: (goals) => state.copyWith(
        status: GoalsLoadStatus.success,
        goals: goals,
      ),
      onError: (_, __) => state.copyWith(
        status: GoalsLoadStatus.failure,
      )
    );
  }
}