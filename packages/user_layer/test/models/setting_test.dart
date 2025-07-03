// Adapted from 
// Github: fenagel/bloc
// examples/flutter_todos/packages/todos_api/test/models/todo_test.dart
import 'package:test/test.dart';
import 'package:user_layer/user_layer.dart';

void main() {
  group('Setting', () {
    Setting createSubject({
      key = 'SettingKey',
      value = false,
    }) {
      return Setting(
        key: key,
        value: value,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            key: null,
            value: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            key: 'New SettingKey',
            value: true
          ),
          equals(
            createSubject(
              key: 'New SettingKey',
              value: true
            ),
          ),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Setting.fromJson(<String, dynamic>{
            'key': 'SettingKey',
            'value': false
          }),
          equals(createSubject()),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{
            'key': 'SettingKey',
            'value': false
          }),
        );
      });
    });
  });
}