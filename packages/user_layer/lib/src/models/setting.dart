import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Setting extends Equatable {
  const Setting({
    required this.key,
    required this.value,
  });

  final String key;
  final bool value;

  @override
  List<Object> get props => [key, value];

  Setting copyWith({
    String? key,
    bool? value,
  }) => Setting(
    key: key ?? this.key,
    value: value ?? this.value,
  );

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    key: json['key'] as String,
    value: json['value'] as bool,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'key': key,
    'value': value
  };
}