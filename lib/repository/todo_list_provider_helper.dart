import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import './db_provider.dart';
import './notifications.dart';
import './todo_object.dart';
import '../root_app.dart';
import '../widgets/error_widget.dart';

abstract class ToDoListProviderInterface
    extends StateNotifier<NotiferProviderState> {
  ToDoListProviderInterface(this.read) : super(NotiferProviderState.init());

  final Reader read;

  Future<void> getData();

  Future<void> edit(final TodoObject todoObject);

  Future<void> delete(final TodoObject todoObject);

  void switchDoneState(final TodoObject todoObject) {
    final index = state.list.indexOf(todoObject);

    final editedTodo = todoObject.copyWith(
      isCompleted: !todoObject.isCompleted,
    );

    replaceItem(index, editedTodo);

    read(dbProvider).edit(editedTodo);
  }

  void setSelectIndex(final TodoObject todoObject) {
    state = state.copyWith(selectedIndex: state.list.indexOf(todoObject));
  }

  Future<void> deleteHandeler(final TodoObject todoObject) async {
    _removeItem(todoObject);

    await read(dbProvider).delete(todoObject.id);

    if (Platform.isAndroid)
      read(notificationsProvider).cancelNotification(todoObject.id);
  }

  Future<TodoObject?> editHandeler(final TodoObject todoObject) async {
    final editedValue = await router.pushNamed(
      'AddEditScreen',
      arguments: todoObject,
    ) as TodoObject?;

    if (editedValue == null || todoObject == editedValue) return null;

    await read(dbProvider).edit(editedValue);

    if (Platform.isAndroid)
      read(notificationsProvider).setScheduleNotification(
        date: editedValue.shouldCompleteDate,
        id: editedValue.id,
        title: editedValue.title,
      );

    return editedValue;
  }

  void _removeItem(final TodoObject todoObject) {
    state = state.copyWith(list: state.list..remove(todoObject));
  }

  void replaceItem(final int index, final TodoObject todoObject) {
    state.list[index] = todoObject;
    state = state.copyWith();
  }

  Future<List<TodoObject>> convertToTodoObject(
    final List<Map<String, Object?>> queryResult,
  ) {
    return compute(_convertToTodoObjectCompute, queryResult);
  }
}

class NotiferProviderState {
  final Object? error;
  final int offset, selectedIndex;
  final List<TodoObject> list;
  final bool hasNextPage, isLoading;

  const NotiferProviderState({
    required final this.list,
    required final this.error,
    required final this.selectedIndex,
    required final this.isLoading,
    required final this.hasNextPage,
    required final this.offset,
  });

  NotiferProviderState.init()
      : list = [],
        error = null,
        isLoading = false,
        hasNextPage = true,
        selectedIndex = 0,
        offset = 0;

  NotiferProviderState copyWith({
    final List<TodoObject>? list,
    final Object? error,
    final bool? isLoading,
    final bool? hasNextPage,
    final int? offset,
    final int? selectedIndex,
  }) {
    return NotiferProviderState(
      list: list ?? this.list,
      error: this.error,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      offset: offset ?? this.offset,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  Widget when({
    required final VoidCallback errorCall,
    required final Widget Function(List<TodoObject> data, BuildContext context)
        onData,
    final String? emptyMessage,
    final double? heightFactor,
  }) {
    return Builder(
      builder: (final context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (isLoading && list.isEmpty)
            ? Center(
                heightFactor: heightFactor,
                child: const CircularProgressIndicator(),
              )
            : (list.isNotEmpty)
                ? onData(list, context)
                : (error != null)
                    ? OnErrorWidget(
                        error: error!,
                        callback: () => errorCall(),
                      )
                    : Center(
                        child: Text(
                          emptyMessage ?? "no_data".tr(),
                          textScaleFactor: 1.0,
                        ),
                      ),
      ),
    );
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is NotiferProviderState &&
        other.error == error &&
        other.selectedIndex == selectedIndex &&
        other.offset == offset &&
        listEquals(other.list, list) &&
        other.hasNextPage == hasNextPage &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode {
    return error.hashCode ^
        offset.hashCode ^
        selectedIndex.hashCode ^
        list.hashCode ^
        hasNextPage.hashCode ^
        isLoading.hashCode;
  }
}

List<TodoObject> _convertToTodoObjectCompute(
  final List<Map<String, Object?>> queryResult,
) {
  return List.from(queryResult.map((final e) => TodoObject.fromMap(e)));
}
