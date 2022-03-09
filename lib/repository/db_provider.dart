import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import './riverpod_context_operations.dart';
import './todo_object.dart';
import '../root_app.dart';
import '../screens/main_screen/tabs/home_tab/providers/month_year_provider.dart';

final dbProvider = Provider<TodosDb>((final ref) {
  throw UnimplementedError();
});

class TodosDb {
  TodosDb(this._path);

  final String _path;

  late Database _db;

  static const _table = 'todo_data';

  Future<void> init() async {
    final dbFile = File('$_path/todo_data.db');

    final isExist = dbFile.existsSync();

    sqfliteFfiInit();

    await _openDb();

    await _db.execute(
      '''CREATE TABLE IF NOT EXISTS $_table
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        addedDate BIGINT NOT NULL,
        shouldCompleteDate BIGINT NOT NULL,
        completeDate BIGINT,
        year INT NOT NULL,
        month SMALLINT NOT NULL,
        day SMALLINT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted SMALLINT NOT NULL
      )
      ''',
    );

    if (!isExist)
      await dbFile.setLastModified(
        DateTime.now().subtract(const Duration(days: 360)),
      );
  }

  Future<List<Map<String, Object?>>> getDayTodo({
    required final int day,
    required final int year,
    required final int month,
  }) {
    return _db.rawQuery(
      '''SELECT * FROM $_table
      WHERE year = $year AND month = $month AND day = $day
      ORDER BY shouldCompleteDate ASC
      ''',
    );
  }

  Future<List<Map<String, Object?>>> getById({required final int id}) {
    return _db.rawQuery(
      'SELECT * FROM $_table WHERE id = $id',
    );
  }

  Future<List<Map<String, Object?>>> getDaysListForMonth({
    required final int month,
    required final int year,
  }) {
    return _db.rawQuery(
      '''SELECT day,COUNT(day) as count FROM $_table
      WHERE year = $year AND month = $month
      GROUP BY day
      ORDER BY day ASC
      ''',
    );
  }

  Future<List<Map<String, Object?>>> search({
    required final String text,
    required final int offset,
    required final bool isCompetedOnly,
    required final DateTimeRange? date,
  }) {
    return _db.rawQuery(
      '''SELECT * FROM $_table
      WHERE (title LIKE '%${text}%' OR  description LIKE '%${text}%')
      ${isCompetedOnly ? 'AND isCompleted = true' : ''}
      ${date != null ? 'AND shouldCompleteDate BETWEEN ${date.start.millisecondsSinceEpoch} and ${date.end.millisecondsSinceEpoch}' : ''}
      LIMIT 20 OFFSET $offset
      ''',
    );
  }

  Future<int> add(final TodoObject data) async {
    return _db.insert(
      _table,
      data.copyWith(addedDate: DateTime.now().millisecondsSinceEpoch).toMap(),
    );
  }

  Future<int> delete(final int id) {
    return _db.delete(_table, where: 'id = $id');
  }

  Future<int> edit(final TodoObject data) {
    return _db.update(
      _table,
      data.toMap(),
      where: 'id = ${data.id}',
    );
  }

  Future<void> updateWithBackup(final List<int> bytes) async {
    final dbFile = File('$_path/todo_data.db');

    await _db.close();

    await dbFile.writeAsBytes(bytes);

    await _openDb();

    // ignore: use_build_context_synchronously
    router.context.read(monthYearProvider).refreshDisplayedData();
  }

  Future<DateTime> getDbModifiedDate() async {
    return File('$_path/todo_data.db').lastModified();
  }

  Future<void> setDbModifiedDate(final DateTime date) async {
    return File('$_path/todo_data.db').setLastModified(date);
  }

  Future<bool> isTableEmpty() {
    return _db.rawQuery('SELECT day,COUNT(day) as count FROM $_table').then(
      (final value) {
        return value.first['count'] == 0;
      },
    );
  }

  Future<void> _openDb() async {
    final dbPath = '$_path/$_table.db';

    if (Platform.isAndroid)
      _db = await openDatabase(dbPath);
    else
      _db = await databaseFactoryFfi.openDatabase(dbPath);
  }
}
