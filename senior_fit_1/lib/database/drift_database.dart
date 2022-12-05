import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../table/feedbackScore.dart';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    FeedbackScores,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createFeedbackScore(FeedbackScoresCompanion data) =>
      into(feedbackScores).insert(data);

  Future<List<FeedbackScore>> getFeedbackScores() =>
      select(feedbackScores).get();

  Future<List<FeedbackScore>> watchFeedbackScores(DateTime startTime) =>
      (select(feedbackScores)..where((tbl)=>tbl.startTime.equals(startTime))).get();

  Future<List<FeedbackScore>> watchFeedbackScoresAct(String activeName) =>
      (select(feedbackScores)..where((tbl)=>tbl.activeName.equals(activeName))).get();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
