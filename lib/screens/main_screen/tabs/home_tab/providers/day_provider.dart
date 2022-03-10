import 'package:hooks_riverpod/hooks_riverpod.dart';

import './month_provider.dart';
import './month_year_provider.dart';
import '../../../../../repository/db_provider.dart';
import '../../../../../repository/notifications.dart';
import '../../../../../repository/todo_list_provider_helper.dart';
import '../../../../../repository/todo_object.dart';
import '../../../../../root_app.dart';

final todoDayProvider = StateNotifierProvider.autoDispose
    .family<DayListProvider, NotiferProviderState, int>((final ref, final day) {
  return DayListProvider(day, ref.read);
});

typedef TodoDayProvider
    = AutoDisposeStateNotifierProvider<DayListProvider, NotiferProviderState>;

class DayListProvider extends ToDoListProviderInterface {
  final int day;

  DayListProvider(this.day, final Reader read) : super(read) {
    getData();
  }

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  Future<void> getData({final bool withLoadingState = true}) async {
    month = read(monthYearProvider).month;
    year = read(monthYearProvider).year;

    if (withLoadingState) state = state.copyWith(isLoading: true);

    try {
      final queryResult = await read(dbProvider).getDayTodo(
        day: day,
        month: month,
        year: year,
      );

      final list = await convertToTodoObject(queryResult);

      if (!mounted) return;

      state = state.copyWith(
        list: list,
        isLoading: false,
      );
    } catch (e) {
      if (mounted) state = state.copyWith(error: e, isLoading: false);
    }
  }

  @override
  Future<void> delete(final TodoObject todoObject) async {
    await deleteHandeler(todoObject);

    read(monthDaysListProvider(month).notifier).getDayes();

    _handelEmptyList();
  }

  @override
  Future<void> edit(final TodoObject todoObject) async {
    final editedValue = await editHandeler(todoObject);

    if (editedValue == null) return;

    if (editedValue.day != day) {
      state = state.copyWith(list: state.list..remove(todoObject));

      read(todoDayProvider(editedValue.day).notifier).getData();

      _handelEmptyList();
    } else {
      final index = state.list.indexOf(todoObject);
      replaceItem(index, editedValue);
    }

    read(monthDaysListProvider(month).notifier).getDayes();
  }

  Future<void> addNew(final TodoObject data) async {
    final id = await read(dbProvider).add(data);

    await read(monthDaysListProvider(data.month).notifier).getDayes();

    if (!mounted) return;

    read(todoDayProvider(data.day).notifier).getData(withLoadingState: false);

    read(notificationsProvider).setScheduleNotification(data.copyWith(id: id));
  }

  void _handelEmptyList() {
    if (!mounted) return;

    if (state.selectedIndex > state.list.length - 1)
      state = state.copyWith(selectedIndex: state.list.length - 1);

    if (state.list.isNotEmpty) return;

    if (router.canPop()) router.pop();
  }
}
