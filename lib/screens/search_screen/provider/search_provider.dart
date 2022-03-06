import 'package:hooks_riverpod/hooks_riverpod.dart';

import './search_helper.dart';
import '../../../repository/db_provider.dart';
import '../../../repository/todo_list_provider_helper.dart';
import '../../../repository/todo_object.dart';

final todoSearchProvider = StateNotifierProvider.autoDispose<
    _SearchProviderMixin, NotiferProviderState>((final ref) {
  return TodoSearchProvider(ref.read);
});

class TodoSearchProvider extends ToDoListProviderInterface
    with _SearchProviderMixin {
  TodoSearchProvider(final Reader read) : super(read) {
    if (searchData.searchText.isNotEmpty) getData(isNewSearch: true);
  }

  static SearchObject searchData = const SearchObject.init();

  @override
  Future<void> getData({final bool isNewSearch = false}) async {
    if (!isNewSearch && (state.isLoading || !state.hasNextPage)) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      offset: isNewSearch ? 0 : state.offset,
      list: isNewSearch ? const [] : state.list,
    );

    try {
      final queryResult = await read(dbProvider).search(
        text: searchData.searchText,
        offset: state.offset,
        date: searchData.date,
        isCompetedOnly: searchData.isCompetedOnly,
      );

      final list = await convertToTodoObject(queryResult);

      if (!mounted) return;

      state = state.copyWith(
        list: state.list + list,
        offset: state.offset + list.length,
        hasNextPage: list.length == 20,
        isLoading: false,
      );
    } catch (e) {
      if (mounted) state = state.copyWith(error: e, isLoading: false);
    }
  }

  @override
  void setSearchText(final String text) {
    if (searchData.searchText == text) return;

    searchData = searchData.copyWith(searchText: text);

    getData(isNewSearch: true);
  }

  @override
  void setSearchData(final SearchObject searchObject) {
    if (searchData == searchObject) return;

    searchData = searchObject;

    getData(isNewSearch: true);
  }

  @override
  Future<void> edit(final TodoObject todoObject) async {
    final editedValue = await editHandeler(todoObject);

    if (editedValue == null) return;

    if (!mounted) return;

    final index = state.list.indexOf(todoObject);

    replaceItem(index, editedValue);
  }

  @override
  Future<void> delete(final TodoObject todoObject) {
    return deleteHandeler(todoObject);
  }
}

typedef TodoListProvider = AutoDisposeStateNotifierProvider<
    ToDoListProviderInterface, NotiferProviderState>;

mixin _SearchProviderMixin on ToDoListProviderInterface {
  void setSearchText(final String text);
  void setSearchData(final SearchObject searchObject);
}
