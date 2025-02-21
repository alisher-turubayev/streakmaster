import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Streak extends Equatable {
  final int days;
  final int? lastTimestamp;

  const Streak({required this.days, this.lastTimestamp});

  @override
  List<Object?> get props => [days, lastTimestamp];

  Streak copyWith({int? days, int? lastTimestamp}) => Streak(
    days: days ?? this.days,
    lastTimestamp: lastTimestamp ?? this.lastTimestamp,
  );

  Streak incrementAndBumpToTimestamp(int timestamp) => Streak(
    days: days + 1,
    lastTimestamp: timestamp,
  );

  factory Streak.fromMap(Map<String, Object?> values) => Streak(
    days: values['days'] as int,
    lastTimestamp: values['last_timestamp'] as int?,
  );

  Map<String, Object?> toMap() => {
    'days': days,
    'last_timestamp': lastTimestamp,
  };
}