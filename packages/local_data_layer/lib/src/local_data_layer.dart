import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:clock/clock.dart';

import 'package:data_layer/data_layer.dart';

class SQLException implements Exception {}
class KeyNotFoundException implements Exception {}
class ValueException implements Exception {}

class LocalDataLayer extends DataLayer {
  late final Database _db;

  late final _streakStreamController = BehaviorSubject<Streak>.seeded(
    Streak(days: 0),
  );
  late final _goalsStreamController = BehaviorSubject<List<Goal>>.seeded(
    const [],
  );
  late final _dailyCheckInsStreamController = BehaviorSubject<List<DailyCheckIn>>.seeded(
    const [],
  );
  late final _milestoneStreamController = BehaviorSubject<List<Milestone>>.seeded(
    const [],
  );

  LocalDataLayer._create();

  // Expose appropriate streams
  @override
  Stream<Streak> getStreak() => _streakStreamController.asBroadcastStream();
  @override
  Stream<List<Goal>> getGoals() => _goalsStreamController.asBroadcastStream();
  @override
  Stream<List<DailyCheckIn>> getDailyCheckIns() => _dailyCheckInsStreamController.asBroadcastStream();
  @override
  Stream<List<Milestone>> getMilestones() => _milestoneStreamController.asBroadcastStream();

  static Future<LocalDataLayer> create(Database? db) async {
    var layer = LocalDataLayer._create();
    // See if we need to initialize the database
    if (db != null) {
      // This allows us to replace db instance with mock class in testing
      layer._db = db;
      return layer;
    }
    var path = await getDatabasesPath();
    layer._db = await openDatabase(
      path,
      onConfigure: (db) async {
        // Enable foreign keys
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        // Initialize the schema and put the starting value for streak table
        await db.execute(
          '''
          CREATE TABLE streak (
            days INT NOT NULL DEFAULT 0,
            last_timestamp INT
          );
          '''
        );
        var response = await db.insert('streak', <String, Object?>{
          'days': 0,
          'last_timestamp': null,
        });
        if (response == 0) {
          // Catastrophic failure - failed to init database so we crash
          throw SQLException();
        }
        // Create the rest of tables - they can be empty
        await db.execute(
          '''
          CREATE TABLE goals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            icon_data_code_point INT,
            timestamp_created INT NOT NULL,
            timestamp_achieved INT
          );
          '''
        );
        await db.execute(
          '''
          CREATE TABLE daily_check_ins (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            last_timestamp INT,
            goal_id INT NOT NULL,
            FOREIGN KEY(goal_id) REFERENCES goals(id)
          );
          '''
        );
        await db.execute(
          '''
          CREATE TABLE milestones (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            icon_data_code_point INT,
            timestamp_achieved INT,
            goal_id INT NOT NULL,
            FOREIGN KEY(goal_id) REFERENCES goals(id)
          );
          '''
        );
      },
      onOpen: (db) async {
        // Must read the database to start providing the data on both the streaks and the goals
        var response = await db.query('streak', columns: ['days', 'last_timestamp']);
        if (response.isEmpty) {
          // Catastrophic failure - no streak data so we crash
          throw SQLException();
        }
        // Unpack and update the stream so everyone knows what streak is
        var streak = Streak.fromMap(response[0]);
        layer._streakStreamController.add(streak);
        // Do the same with other data
        // TODO: check the time it takes to initialize with a lot of data
        // might have to rethink if it's a good idea or whether I should instead open dedicated streams
        response = await db.query(
          'goals',
          columns: ['id', 'name', 'description', 'icon_data_point', 'timestamp_created', 'timestamp_achieved'],
        );
        if (response.isNotEmpty) {
          List<Goal> goals = [];
          for (final values in response) {
            goals.add(Goal.fromMap(values));
          }
          layer._goalsStreamController.add(goals);
        }
        response = await db.query(
          'daily_check_ins',
          columns: ['id', 'name', 'description', 'last_timestamp', 'goal_id'],
        );
        if (response.isNotEmpty) {
          List<DailyCheckIn> dailyCheckIns = [];
          for (final values in response) {
            dailyCheckIns.add(DailyCheckIn.fromMap(values));
          } 
          layer._dailyCheckInsStreamController.add(dailyCheckIns);
        }
        response = await db.query(
          'milestone',
          columns: ['id', 'name', 'description', 'icon_data_code_point','timestamp_achieved', 'goal_id'],
        );
        if (response.isNotEmpty) {
          List<Milestone> milestones = [];
          for (final values in response) {
            milestones.add(Milestone.fromMap(values));
          }
          layer._milestoneStreamController.add(milestones);
        }
      },
    );
    return layer;
  }

  // CRUD operations
  // Should not be used by consumers - see instead _streakStreamController
  @override
  Future<Streak> readStreak() async {
    var response = await _db.query('streak', columns: ['days', 'lastTimestamp']);
    if (response.isEmpty || response.length > 1) {
      throw SQLException();
    }
    return Streak.fromMap(response[0]);
  }

  @override
  Future<void> updateStreak(int timestamp) async {
    Streak currentStreak = await readStreak();
    if (currentStreak.lastTimestamp != null) {
      // Calculate the nearest midnight for the currently stored timestamp
      // and check if the passed timestamp is after that
      var currTs = DateTime.fromMillisecondsSinceEpoch(currentStreak.lastTimestamp!);
      currTs = currTs.roundToNearestMidnight();
      var newTs = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (!currTs.isBefore(newTs)) {
        // The function call was unexpected in this case, we should only be called when
        // a day has passed
        throw ValueException();
      }
    }
    // Bump to new timestamp and prepare for db update
    currentStreak = currentStreak.incrementAndBumpToTimestamp(timestamp);
    var values = currentStreak.toMap();

    var response = await _db.update('streak', values);
    if (response != 1) {
      // Means we somehow arrived at more than one streak in the singleton table
      throw SQLException();
    }
    // Notify of change
    _streakStreamController.add(currentStreak);
  }

  // CRUD operations for goals
  @override
  Future<void> createGoal({
    required String name,
    String? description,
    int? iconDataCodePoint
  }) async {
    // Get current timestamp
    int timestampCreated = clock.now().millisecondsSinceEpoch;
    var values = <String, Object?>{
      'name': name,
      'description': description,
      'icon_data_codepoint': iconDataCodePoint,
    };

    var id = await _db.insert('goals', values);
    if (id == 0) {
      throw SQLException();
    }
    var newGoal = Goal(
      id: id,
      name: name,
      description: description,
      iconDataCodePoint: iconDataCodePoint,
      timestampCreated: timestampCreated,
    );
    // Notify listeners
    var goalsList = [..._goalsStreamController.value];
    goalsList.add(newGoal);
    _goalsStreamController.add(goalsList);
  }

  @override
  Future<Goal> readGoal(int id) async {
    var response = await _db.query(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (response.isEmpty || response.length != 1) {
      throw KeyNotFoundException();
    }
    return Goal.fromMap(response[0]);
  }
  
  @override
  Future<void> updateGoal({
    required int id,
    String? name,
    String? description,
    int? iconDataCodePoint,
    int? timestampAchieved,
  }) async {
    var goalsList = [..._goalsStreamController.value];
    var goal = goalsList.firstWhere((g) => g.id == id, orElse: () => throw KeyNotFoundException());

    var values = <String, Object?>{};
    if (name != null && name != goal.name) {
      values['name'] = name;
    }
    if (description != null && description != goal.description) {
      values['description'] = description;
    }
    if (iconDataCodePoint != null && iconDataCodePoint != goal.iconDataCodePoint) {
      values['icon_data_code_point'] = iconDataCodePoint;
    }
    if (timestampAchieved != null && timestampAchieved != goal.timestampAchieved) {
      values['timestamp_achived'] = timestampAchieved;
    }
    // No updates necessary
    if (values.isEmpty) {
      return;
    }
    var response = await _db.update(
      'goals', values, where: 'id = ?', whereArgs: [id],
    );
    if (response != 1) {
      throw SQLException();
    }

    // Notify listeners
    // Guaranteed to work as we crash previously
    int index = goalsList.indexWhere((goal) => goal.id == id);
    goalsList[index] = goalsList[index].copyWith(
      name: name,
      description: description,
      iconDataCodePoint: iconDataCodePoint,
      timestampAchieved: timestampAchieved,
    );
    _goalsStreamController.add(goalsList);
  }

  @override
  Future<void> deleteGoal(int id) async {
    var response = await _db.delete('goals', where: 'id = ?', whereArgs: [id]);
    if (response != 1) {
      // Deleted none or somehow deleted more than one
      throw SQLException();
    }
    // Notify listeners
    List<Goal> goals = [..._goalsStreamController.value];
    goals.removeWhere((goal) => goal.id == id);
    _goalsStreamController.add(goals);
  }

  // CRUD operations for dailyCheckins
  @override
  Future<void> createDailyCheckIn({
    required String name,
    String? description,
    required int goalID
  }) async {
    // Check if goal id is valid
    var goalsList = [..._goalsStreamController.value];
    if (goalsList.indexWhere((goal) => goal.id == goalID) == -1) {
      throw KeyNotFoundException();
    }
    
    var values = <String, Object?>{
      'name': name,
      'description': description, 
      'goal_id': goalID,
    };
    var id = await _db.insert('dailycheckins', values);
    // Notify listeners
    List<DailyCheckIn> dailyCheckIns = [..._dailyCheckInsStreamController.value];
    dailyCheckIns.add(DailyCheckIn(id: id, name: name, goalID: goalID));
    _dailyCheckInsStreamController.add(dailyCheckIns);
  }

  @override
  Future<DailyCheckIn> readDailyCheckIn(int id) async {
    var response = await _db.query('daily_check_ins', where: 'id = ?', whereArgs: [id],);
    if (response.length != 1) {
      throw SQLException();
    }
    return DailyCheckIn.fromMap(response[0]);
  }

  @override
  Future<void> updateDailyCheckIn({
    required int id,
    String? name,
    String? description,
    int? lastTimestamp,
    required int goalID,
  }) async {
    // First, verify we need an update to begin with
    var dailyCheckIns = [..._dailyCheckInsStreamController.value];
    var curr = dailyCheckIns.firstWhere(
      (d) => d.id == id,
      orElse: () => throw KeyNotFoundException()
    );
    
    var values = <String, Object>{};
    if (name != null && curr.name != name) {
      values['name'] = name;
    }
    if (description != null && curr.description != description) {
      values['description'] = description;
    }
    if (lastTimestamp != null && curr.lastTimestamp != lastTimestamp) {
      values['last_timestamp'] = lastTimestamp;
    }
    if (goalID != curr.goalID) {
      values['goal_id'] = goalID;
    }
    // Check if update is required
    if (values.isEmpty) {
      return;
    }
    var response = await _db.update(
      'daily_check_ins',
      values, where: 'id = ?',
      whereArgs: [id],
    );

    if (response != 1) {
      throw SQLException();
    }
    // Notify the listeners
    var index = dailyCheckIns.indexWhere((d) => d.id == id);
    // We are guaranteed to have an index bc we would have previously failed
    //  with .firstWhere lookup
    dailyCheckIns[index] = dailyCheckIns[index].copyWith(
      name: name,
      description: description,
      lastTimestamp: lastTimestamp,
      goalID: goalID,
    );
    _dailyCheckInsStreamController.add(dailyCheckIns);
  }

  @override
  Future<void> deleteDailyCheckIn(int id) async {
    var response = await _db.delete(
      'daily_check_ins',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (response != 1) {
      throw SQLException();
    }
    // Notify listeners
    List<DailyCheckIn> dailyCheckIns = [..._dailyCheckInsStreamController.value];
    dailyCheckIns.removeWhere((d) => d.id == id);
    _dailyCheckInsStreamController.add(dailyCheckIns);
  }

  // CRUD operations for Milestones
  @override
  Future<void> createMilestone({
    required String name,
    String? description,
    int? iconDataCodePoint,
    required int goalID
  }) async {
    // Check if goal exists
    List<Goal> goals = [..._goalsStreamController.value];
    if (goals.indexWhere((g) => g.id == goalID) == -1) {
      throw KeyNotFoundException();
    }
    Map<String, Object?> values = {
      'name': name,
      'description': description,
      'icon_data_code_point': iconDataCodePoint,
      'goal_id': goalID,
    };
    var id = await _db.insert('milestones', values);
    if (id == 0) {
      throw SQLException();
    }
    // Notify listeners
    List<Milestone> milestones = [..._milestoneStreamController.value];
    milestones.add(Milestone(
      id: id,
      name: name,
      description: description,
      iconDataCodePoint: iconDataCodePoint,
      goalID: goalID,
    ));
    _milestoneStreamController.add(milestones);
  }

  @override
  Future<Milestone> readMilestone(int id) async {
    var response = await _db.query(
      'milestones',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (response.isEmpty || response.length > 1) {
      throw SQLException();
    }
    return Milestone.fromMap(response[0]);
  }

  @override
  Future<void> updateMilestone({
    required int id,
    String? name,
    String? description,
    int? iconDataCodePoint,
    int? timestampAchieved,
    required int goalID,
  }) async {
    // First, verify if we need to update to begin with
    var milestones = [..._milestoneStreamController.value];
    var curr = milestones.firstWhere(
      (m) => m.id == id,
      orElse: () => throw KeyNotFoundException()
    );

    var values = <String, Object?>{};
    if (name != null && name != curr.name) {
      values['name'] = name;
    }
    if (description != null && description != curr.description) {
      values['description'] = description;
    } 
    if (iconDataCodePoint != null && iconDataCodePoint != curr.iconDataCodePoint) {
      values['icon_data_code_point'] = iconDataCodePoint;
    }
    if (timestampAchieved != null && timestampAchieved != curr.timestampAchieved) {
      values['timestamp_achieved'] = timestampAchieved;
    }
    if (goalID != curr.goalID) {
      values['goalID'] = goalID;
    }
    // No update necessary
    if (values.isEmpty) {
      return;
    }
    var response = await _db.update(
      'milestones',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (response != 1) {
      throw SQLException();
    }
    // Notify listeners
    var index = milestones.indexWhere((m) => m.id == id);
    milestones[index] = milestones[index].copyWith(
      name: name,
      description: description,
      iconDataCodePoint: iconDataCodePoint,
      timestampAchieved: timestampAchieved,
      goalID: goalID,
    );
    _milestoneStreamController.add(milestones);
  }
  
  @override
  Future<void> deleteMilestone(int id) async {
    var response = await _db.delete('milestones', where: 'id = ?', whereArgs: [id],);
    if (response != 1) {
      throw SQLException();
    }
    // Notify listeners
    List<Milestone> milestones = [..._milestoneStreamController.value];
    milestones.removeWhere((m) => m.id == id);
    _milestoneStreamController.add(milestones);
  }

  // Close the connection
  void close() async {
    await _db.close();
  }
}

extension DateRounding on DateTime {
  DateTime roundToNearestMidnight() => copyWith(
    hour: 23,
    minute: 59,
    second: 59,
    millisecond: 999,
    microsecond: 999,
  );
}