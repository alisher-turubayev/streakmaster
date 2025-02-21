// Adapted from 
// Github: fenagel/bloc
// examples/flutter_todos/packages/todos_api/test/models/todo_test.dart
import 'package:test/test.dart';
import 'package:data_layer/data_layer.dart';

void main() {
  group('DailyCheckIn', () {
    DailyCheckIn createSubject({
      int id = 1,
      String name = 'title',
      String description = 'description',
      int lastTimestamp = 0,
      int goalID = 1,
    }) {
      return DailyCheckIn(
        id: id,
        name: name,
        description: description,
        lastTimestamp: lastTimestamp,
        goalID: goalID,
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
            name: null,
            description: null,
            lastTimestamp: null,
            goalID: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            name: 'new title',
            description: 'new description',
            lastTimestamp: 1,
            goalID: 2,
          ),
          equals(
            createSubject(
              id: 1,
              name: 'new title',
              description: 'new description',
              lastTimestamp: 1,
              goalID: 2,
            ),
          ),
        );
      });
    });

    group('fromMap', () {
      test('works correctly', () {
        expect(
          DailyCheckIn.fromMap(<String, Object?>{
            'id': 1,
            'name': 'title',
            'description': 'description',
            'last_timestamp': 0,
            'goal_id': 1,
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
            'id': 1,
            'name': 'title',
            'description': 'description',
            'last_timestamp': 0,
            'goal_id': 1,
          }),
        );
      });
    });
  });
}