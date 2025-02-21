import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class DailyCheckIn extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int? lastTimestamp;
  final int goalID;

  const DailyCheckIn({
    required this.id,
    required this.name,
    this.description,
    this.lastTimestamp,
    required this.goalID,
  });

  @override
  List<Object?> get props => [id, name, description, lastTimestamp, goalID];

  DailyCheckIn copyWith({
    String? name,
    String? description,
    int? lastTimestamp,
    int? goalID,
  }) => DailyCheckIn(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    lastTimestamp: lastTimestamp ?? this.lastTimestamp,
    goalID: goalID ?? this.goalID,
  );

  factory DailyCheckIn.fromMap(Map<String, Object?> values) => DailyCheckIn(
    id: values['id'] as int,
    name: values['name'] as String,
    description: values['description'] as String?,
    lastTimestamp: values['last_timestamp'] as int?,
    goalID: values['goal_id'] as int,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'last_timestamp': lastTimestamp,
    'goal_id': goalID,
  };
}