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

  Future<void> updateStreak(int timestamp) => _dataLayer.updateStreak(timestamp);
  
  Future<void> createGoal({
    required String name,
    String? description,
    int? iconDataCodePoint
  }) => _dataLayer.createGoal(
    name: name,
    description: description,
    iconDataCodePoint: iconDataCodePoint
  );
  Future<void> updateGoal({
    required int id,
    String? name,
    String? description,
    int? iconDataCodePoint,
    int? timestampAchieved,
  }) => _dataLayer.updateGoal(
    id: id,
    name: name,
    description: description,
    iconDataCodePoint: iconDataCodePoint,
    timestampAchieved: timestampAchieved
  );
  Future<void> deleteGoal(int id) => _dataLayer.deleteGoal(id);

  Future<void> createDailyCheckIn({
    required String name,
    String? description,
    required int goalID,
  }) => _dataLayer.createDailyCheckIn(
    name: name,
    description: description,
    goalID: goalID
  );
  Future<void> updateDailyCheckIn({
    required int id,
    String? name,
    String? description,
    int? lastTimestamp,
    required int goalID,
  }) => _dataLayer.updateDailyCheckIn(
    id: id,
    name: name,
    description: description,
    lastTimestamp: lastTimestamp,
    goalID: goalID
  );
  Future<void> deleteDailyCheckIn(int id) => _dataLayer.deleteDailyCheckIn(id);
}