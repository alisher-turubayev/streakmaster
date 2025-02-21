import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Milestone extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int? iconDataCodePoint;
  final int? timestampAchieved;
  final int goalID;

  const Milestone({
    required this.id,
    required this.name,
    this.description,
    this.iconDataCodePoint,
    this.timestampAchieved,
    required this.goalID,
  }); 

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    iconDataCodePoint,
    timestampAchieved,
    goalID,
  ];

  Milestone copyWith({
    String? name,
    String? description,
    int? iconDataCodePoint,
    int? timestampAchieved,
    int? goalID,
  }) => Milestone(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    iconDataCodePoint: iconDataCodePoint ?? this.iconDataCodePoint,
    timestampAchieved: timestampAchieved ?? this.timestampAchieved,
    goalID: goalID ?? this.goalID,
  );

  factory Milestone.fromMap(Map<String, Object?> values) => Milestone(
    id: values['id'] as int,
    name: values['name'] as String,
    description: values['description'] as String?,
    iconDataCodePoint: values['icon_data_code_point'] as int?,
    timestampAchieved: values['timestamp_achieved'] as int?,
    goalID: values['goal_id'] as int,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'icon_data_code_point': iconDataCodePoint,
    'timestamp_achieved': timestampAchieved,
    'goal_id': goalID,
  };
}