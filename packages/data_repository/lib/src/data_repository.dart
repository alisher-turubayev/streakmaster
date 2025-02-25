import 'package:data_layer/data_layer.dart';
import 'package:user_layer/user_layer.dart';

class DataRepository {
  DataRepository({
    required DataLayer dataLayer,
    required UserLayer userLayer,
  }) : _dataLayer = dataLayer,
      _userLayer = userLayer;

  final DataLayer _dataLayer;
  final UserLayer _userLayer;

  Stream<Streak> getStreak() => _dataLayer.getStreak();
  Stream<List<Goal>> getGoals() => _dataLayer.getGoals();
  Stream<List<DailyCheckIn>> getDailyCheckIns() => _dataLayer.getDailyCheckIns();
  Stream<List<Milestone>> getMilestones() => _dataLayer.getMilestones();
}