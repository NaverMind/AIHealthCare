import 'package:drift/drift.dart';

class FeedbackScores extends Table {
  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  TextColumn get activeName => text()();

  DateTimeColumn get startTime => dateTime()();

  TextColumn get feedback => text()();

  TextColumn get part => text()();

  IntColumn get score => integer()();

  // row 생성날짜
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
      )();
}
