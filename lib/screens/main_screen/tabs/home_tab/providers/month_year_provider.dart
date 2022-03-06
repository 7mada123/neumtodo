import 'package:hooks_riverpod/hooks_riverpod.dart';

import './month_provider.dart';

final monthYearProvider = Provider<_MonthYear>((final ref) {
  return _MonthYear(ref);
});

class _MonthYear {
  final ProviderRef<_MonthYear> _ref;

  _MonthYear(this._ref);

  int month = DateTime.now().month - 1;
  int year = DateTime.now().year;

  void setTime({final int? month, final int? year}) {
    if (this.month == month && (year == null || this.year == year)) return;

    this.month = month ?? this.month;
    this.year = year ?? this.year;
  }

  void refreshDisplayedData() => _ref.refresh(
        monthDaysListProvider(month).notifier,
      );
}
