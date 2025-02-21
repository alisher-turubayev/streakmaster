// Adapted from 
// Github: fenagel/bloc
// examples/flutter_todos/packages/todos_api/test/models/todo_test.dart
import 'package:test/test.dart';
import 'package:data_layer/data_layer.dart';

void main() {
  group('Streak', () {
    Streak createSubject({
      int days = 0,
      int lastTimestamp = 0,
    }) {
      return Streak(
        days: days,
        lastTimestamp: lastTimestamp,
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
            days: null,
            lastTimestamp: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            days: 1,
            lastTimestamp: 86400001,
          ),
          equals(
            createSubject(
              days: 1,
              lastTimestamp: 86400001,
            ),
          ),
        );
      });
    });

    group('incrementAndBumpToTimestamp', () {
      test('works correctly', () {
        expect(
          createSubject().incrementAndBumpToTimestamp(86400001),
          equals(
            createSubject(
              days: 1,
              lastTimestamp: 86400001,
            )
          )
        );
      });
    });

    group('fromMap', () {
      test('works correctly', () {
        expect(
          Streak.fromMap(<String, Object?>{
            'days': 0,
            'last_timestamp': 0,
          }),
          equals(createSubject()),
        );
      });
    });

    group('toMap', () {
      test('works correctly', () {
        expect(
          createSubject().toMap(),
          equals(<String, Object?>{
            'days': 0,
            'last_timestamp': 0,
          }),
        );
      });
    });
  });
}