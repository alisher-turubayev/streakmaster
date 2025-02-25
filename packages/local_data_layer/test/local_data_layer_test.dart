import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import 'package:clock/clock.dart';

import 'package:local_data_layer/local_data_layer.dart';
import 'package:data_layer/data_layer.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late Database db;

  setUp(() async {
    db = MockDatabase();
    // Set up expected close behaviour
    when(() => db.close()).thenAnswer((_) async {});
  });

  Future<LocalDataLayer> createSubject({
    required Database db
  }) async => LocalDataLayer.create(db);

  group('LocalDataLayer', () {
    group('init', () {
      test('works as expected', () async {
        expect(
          await createSubject(db: db),
          isA<LocalDataLayer>()
        );
      });
    });

    group('getStreak stream', () {
      test('should contain stub value at start', () async {
        final subject = await createSubject(db: db);
        expect(
          subject.getStreak(),
          isA<Stream<Streak>>()
        );
        expect(
          subject.getStreak(),
          emits(
            Streak(
              days: 0
            )
          ),
        );
      });

      test('should change stream value on updateStreak', () async {
        when(() => db.query(
          'streak',
          columns: any(named: 'columns', that: isList)
        )).thenAnswer(
          (_) async => [
            Streak(days: 0).toMap()
          ]
        );
        when(() => db.update('streak', any())).thenAnswer(
          (_) async => 1
        );

        final subject = await createSubject(db: db);
        await subject.updateStreak(86400001);
        // Expect the updated value
        expect(
          subject.getStreak(),
          emits(
            Streak(
              days: 1,
              lastTimestamp: 86400001
            )
          ),
        );
      });
    });

    group('getGoals stream', () {
      test('should contain stub value at start', () async {
        final subject = await createSubject(db: db);
        expect(
          subject.getGoals(),
          emits(
            []
          ),
        );
      });

      test('should change stream value on addGoal', () async {
        // Must fix the clock to ensure consistent timestamps
        withClock(Clock.fixed(DateTime.fromMillisecondsSinceEpoch(0)), () async {
          when(() => db.insert('goals', any())).thenAnswer((_) async => 1);

          final subject = await createSubject(db: db);

          await subject.createGoal(
            name: 'title',
            description: 'description',
            iconDataCodePoint: 0x1F600
          );

          expect(
            subject.getGoals(),
            emits(
              Goal(
                id: 1,
                name: 'title',
                description: 'description',
                iconDataCodePoint: 0x1F600,
                timestampCreated: 0,
                timestampAchieved: null,
              ),            
            ),
          );
        });
      });

      test('should change stream value on update', () async {
        // Must fix the clock to ensure consistent timestamps
        withClock(Clock.fixed(DateTime.fromMillisecondsSinceEpoch(0)), () async {
          when(() => db.insert('goals', any())).thenAnswer((_) async => 1);
          
          when(() => db.update(
            'goals',
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs')
          )).thenAnswer((_) async => 1);

          // First, insert a value
          final subject = await createSubject(db: db);
          await subject.createGoal(
            name: 'title',
            description: 'description',
            iconDataCodePoint: 0x1F600,
          );        
          // Now, force an update
          await subject.updateGoal(
            id: 1,
            name: 'new title',
          );
          expect(
            subject.getGoals(),
            emits(
              Goal(
                id: 1,
                name: 'new title',
                description: 'description',
                iconDataCodePoint: 0x1F600,
                timestampCreated: 0,
                timestampAchieved: null,
              )
            ),
          );
        });
      });

      test('should not change value on update with same params', () async {
        // Must fix the clock to ensure consistent timestamps
        withClock(Clock.fixed(DateTime.fromMillisecondsSinceEpoch(0)), () async {
          when(() => db.insert('goals', any())).thenAnswer((_) async => 1);
          
          when(() => db.update(
            'goals',
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs')
          )).thenAnswer((_) async => 1);

          // First, insert a value
          final subject = await createSubject(db: db);
          await subject.createGoal(
            name: 'title',
            description: 'description',
            iconDataCodePoint: 0x1F600,
          );        
          // Now, force an update
          await subject.updateGoal(
            id: 1,
            name: 'title',
          );
          expect(
            subject.getGoals(),
            emits(
              Goal(
                id: 1,
                name: 'title',
                description: 'description',
                iconDataCodePoint: 0x1F600,
                timestampCreated: 0,
                timestampAchieved: null,
              )
            ),
          );
          // Make sure no updates were called on the database either
          verifyNever(() => db.update(
            'goals',
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs')
          ));
        });
      });

      test('verify throws on invalid goalID', () async {
        final subject = await createSubject(db: db);

        expect(
          subject.updateGoal(id: 1, name: 'new title'),
          throwsA(isA<KeyNotFoundException>()),
        );
      });

      test('verify throws on invalid database answer', () async {
        when(() => db.insert('goals', any())).thenAnswer((_) async => 0);

        final subject = await createSubject(db: db);

        expect(
          subject.createGoal(name: 'title'),
          throwsA(isA<SQLException>()),
        );
      });
    });
  });
}