import 'package:data_layer/data_layer.dart';

abstract class DataLayer {
  const DataLayer();

  Stream<Streak> getStreak();
  Stream<List<Goal>> getGoals();
  Stream<List<DailyCheckIn>> getDailyCheckIns();
  Stream<List<Milestone>> getMilestones();

  // CRUD operations
  Future<Streak> readStreak();
  Future<void> updateStreak(int timestamp);

  Future<void> createGoal({
    required String name,
    String? description,
    int? iconDataCodePoint,
  });
  Future<Goal> readGoal(int id);
  Future<void> updateGoal({
    required int id,
    String? name, 
    String? description,
    int? iconDataCodePoint,
    int? timestampAchieved,
  });
  Future<void> deleteGoal(int id);

  Future<void> createDailyCheckIn({
    required String name,
    String? description,
    required int goalID,
  });
  Future<DailyCheckIn> readDailyCheckIn(int id);
  Future<void> updateDailyCheckIn({
    required int id,
    String? name,
    String? description,
    int? lastTimestamp,
    required int goalID,
  });
  Future<void> deleteDailyCheckIn(int id);

  Future<void> createMilestone({
    required String name,
    String? description,
    int? iconDataCodePoint,
    required int goalID,
  });
  Future<Milestone> readMilestone(int id);
  Future<void> updateMilestone({
    required int id,
    String? name,
    String? description,
    int? iconDataCodePoint,
    int? timestampAchieved,
    required int goalID
  });
  Future<void> deleteMilestone(int id);
}