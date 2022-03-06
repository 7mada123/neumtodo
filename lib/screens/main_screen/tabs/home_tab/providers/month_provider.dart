import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './month_year_provider.dart';
import '../../../../../repository/db_provider.dart';

final monthDaysListProvider = ChangeNotifierProvider.autoDispose
    .family<_MonthProvider, int>((final ref, final month) {
  return _MonthProvider(ref.read, month);
});

class _MonthProvider extends ChangeNotifier {
  final Reader read;

  final int month;

  bool isLoading = true;

  List<DayTodo> daysList = [];

  _MonthProvider(this.read, this.month) {
    read(monthYearProvider).setTime(month: month);

    getDayes();
  }

  bool _isMounted = true;

  @override
  void dispose() {
    super.dispose();
    _isMounted = false;
  }

  Future<void> getDayes() async {
    final queryResult = await read(dbProvider).getDaysListForMonth(
      month: month,
      year: read(monthYearProvider).year,
    );

    daysList = await compute(_getDays, queryResult);

    isLoading = false;

    if (_isMounted) notifyListeners();
  }
}

List<DayTodo> _getDays(final List<Map<String, Object?>> queryResult) {
  return List<DayTodo>.from(queryResult.map((final e) => DayTodo.fromMap(e)));
}

class DayTodo {
  final int day;
  final int count;

  const DayTodo({
    required this.day,
    required this.count,
  });

  DayTodo copyWith({
    final int? day,
    final int? count,
  }) {
    return DayTodo(
      day: day ?? this.day,
      count: count ?? this.count,
    );
  }

  factory DayTodo.fromMap(final Map<String, dynamic> map) {
    return DayTodo(
      day: map['day'],
      count: map['count'],
    );
  }

  @override
  bool operator ==(final other) {
    if (identical(this, other)) return true;

    return other is DayTodo && other.day == day && other.count == count;
  }

  @override
  int get hashCode => day.hashCode ^ count.hashCode;
}
