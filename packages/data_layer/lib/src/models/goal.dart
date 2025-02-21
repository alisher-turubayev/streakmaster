import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Goal extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int? iconDataCodePoint;
  final int timestampCreated;
  final int? timestampAchieved;

  const Goal({
    required this.id,
    required this.name,
    this.description,
    this.iconDataCodePoint,
    required this.timestampCreated,
    this.timestampAchieved,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    iconDataCodePoint,
    timestampCreated,
    timestampAchieved
  ];

  Goal copyWith({
    String? name,
    String? description,
    int? iconDataCodePoint,
    int? timestampAchieved
  }) => Goal(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    iconDataCodePoint: iconDataCodePoint ?? this.iconDataCodePoint,
    timestampCreated: timestampCreated,
    timestampAchieved: timestampAchieved ?? this.timestampAchieved
  );

  factory Goal.fromMap(Map<String, Object?> values) => Goal(
    id: values['id'] as int,
    name: values['name'] as String,
    description: values['description'] as String?,
    iconDataCodePoint: values['icon_data_code_point'] as int?,
    timestampCreated: values['timestamp_created'] as int, 
    timestampAchieved: values['timestamp_achieved'] as int?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'icon_data_code_point': iconDataCodePoint,
    'timestamp_created': timestampCreated,
    'timestamp_achieved': timestampAchieved,
  };
}