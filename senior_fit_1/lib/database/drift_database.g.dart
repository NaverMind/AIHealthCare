// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class FeedbackScore extends DataClass implements Insertable<FeedbackScore> {
  final int id;
  final String activeName;
  final DateTime startTime;
  final String feedback;
  final String part;
  final int score;
  final DateTime createdAt;
  const FeedbackScore(
      {required this.id,
      required this.activeName,
      required this.startTime,
      required this.feedback,
      required this.part,
      required this.score,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['active_name'] = Variable<String>(activeName);
    map['start_time'] = Variable<DateTime>(startTime);
    map['feedback'] = Variable<String>(feedback);
    map['part'] = Variable<String>(part);
    map['score'] = Variable<int>(score);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FeedbackScoresCompanion toCompanion(bool nullToAbsent) {
    return FeedbackScoresCompanion(
      id: Value(id),
      activeName: Value(activeName),
      startTime: Value(startTime),
      feedback: Value(feedback),
      part: Value(part),
      score: Value(score),
      createdAt: Value(createdAt),
    );
  }

  factory FeedbackScore.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedbackScore(
      id: serializer.fromJson<int>(json['id']),
      activeName: serializer.fromJson<String>(json['activeName']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      feedback: serializer.fromJson<String>(json['feedback']),
      part: serializer.fromJson<String>(json['part']),
      score: serializer.fromJson<int>(json['score']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activeName': serializer.toJson<String>(activeName),
      'startTime': serializer.toJson<DateTime>(startTime),
      'feedback': serializer.toJson<String>(feedback),
      'part': serializer.toJson<String>(part),
      'score': serializer.toJson<int>(score),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FeedbackScore copyWith(
          {int? id,
          String? activeName,
          DateTime? startTime,
          String? feedback,
          String? part,
          int? score,
          DateTime? createdAt}) =>
      FeedbackScore(
        id: id ?? this.id,
        activeName: activeName ?? this.activeName,
        startTime: startTime ?? this.startTime,
        feedback: feedback ?? this.feedback,
        part: part ?? this.part,
        score: score ?? this.score,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('FeedbackScore(')
          ..write('id: $id, ')
          ..write('activeName: $activeName, ')
          ..write('startTime: $startTime, ')
          ..write('feedback: $feedback, ')
          ..write('part: $part, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, activeName, startTime, feedback, part, score, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackScore &&
          other.id == this.id &&
          other.activeName == this.activeName &&
          other.startTime == this.startTime &&
          other.feedback == this.feedback &&
          other.part == this.part &&
          other.score == this.score &&
          other.createdAt == this.createdAt);
}

class FeedbackScoresCompanion extends UpdateCompanion<FeedbackScore> {
  final Value<int> id;
  final Value<String> activeName;
  final Value<DateTime> startTime;
  final Value<String> feedback;
  final Value<String> part;
  final Value<int> score;
  final Value<DateTime> createdAt;
  const FeedbackScoresCompanion({
    this.id = const Value.absent(),
    this.activeName = const Value.absent(),
    this.startTime = const Value.absent(),
    this.feedback = const Value.absent(),
    this.part = const Value.absent(),
    this.score = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FeedbackScoresCompanion.insert({
    this.id = const Value.absent(),
    required String activeName,
    required DateTime startTime,
    required String feedback,
    required String part,
    required int score,
    this.createdAt = const Value.absent(),
  })  : activeName = Value(activeName),
        startTime = Value(startTime),
        feedback = Value(feedback),
        part = Value(part),
        score = Value(score);
  static Insertable<FeedbackScore> custom({
    Expression<int>? id,
    Expression<String>? activeName,
    Expression<DateTime>? startTime,
    Expression<String>? feedback,
    Expression<String>? part,
    Expression<int>? score,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activeName != null) 'active_name': activeName,
      if (startTime != null) 'start_time': startTime,
      if (feedback != null) 'feedback': feedback,
      if (part != null) 'part': part,
      if (score != null) 'score': score,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FeedbackScoresCompanion copyWith(
      {Value<int>? id,
      Value<String>? activeName,
      Value<DateTime>? startTime,
      Value<String>? feedback,
      Value<String>? part,
      Value<int>? score,
      Value<DateTime>? createdAt}) {
    return FeedbackScoresCompanion(
      id: id ?? this.id,
      activeName: activeName ?? this.activeName,
      startTime: startTime ?? this.startTime,
      feedback: feedback ?? this.feedback,
      part: part ?? this.part,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activeName.present) {
      map['active_name'] = Variable<String>(activeName.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (feedback.present) {
      map['feedback'] = Variable<String>(feedback.value);
    }
    if (part.present) {
      map['part'] = Variable<String>(part.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackScoresCompanion(')
          ..write('id: $id, ')
          ..write('activeName: $activeName, ')
          ..write('startTime: $startTime, ')
          ..write('feedback: $feedback, ')
          ..write('part: $part, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FeedbackScoresTable extends FeedbackScores
    with TableInfo<$FeedbackScoresTable, FeedbackScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedbackScoresTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _activeNameMeta = const VerificationMeta('activeName');
  @override
  late final GeneratedColumn<String> activeName = GeneratedColumn<String>(
      'active_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _startTimeMeta = const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _feedbackMeta = const VerificationMeta('feedback');
  @override
  late final GeneratedColumn<String> feedback = GeneratedColumn<String>(
      'feedback', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _partMeta = const VerificationMeta('part');
  @override
  late final GeneratedColumn<String> part = GeneratedColumn<String>(
      'part', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
  @override
  List<GeneratedColumn> get $columns =>
      [id, activeName, startTime, feedback, part, score, createdAt];
  @override
  String get aliasedName => _alias ?? 'feedback_scores';
  @override
  String get actualTableName => 'feedback_scores';
  @override
  VerificationContext validateIntegrity(Insertable<FeedbackScore> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('active_name')) {
      context.handle(
          _activeNameMeta,
          activeName.isAcceptableOrUnknown(
              data['active_name']!, _activeNameMeta));
    } else if (isInserting) {
      context.missing(_activeNameMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('feedback')) {
      context.handle(_feedbackMeta,
          feedback.isAcceptableOrUnknown(data['feedback']!, _feedbackMeta));
    } else if (isInserting) {
      context.missing(_feedbackMeta);
    }
    if (data.containsKey('part')) {
      context.handle(
          _partMeta, part.isAcceptableOrUnknown(data['part']!, _partMeta));
    } else if (isInserting) {
      context.missing(_partMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedbackScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedbackScore(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      activeName: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}active_name'])!,
      startTime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      feedback: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}feedback'])!,
      part: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}part'])!,
      score: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FeedbackScoresTable createAlias(String alias) {
    return $FeedbackScoresTable(attachedDatabase, alias);
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $FeedbackScoresTable feedbackScores = $FeedbackScoresTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [feedbackScores];
}
