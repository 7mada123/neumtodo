import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../repository/db_provider.dart';
import '../../../repository/todo_object.dart';

final singleTodoProvider = FutureProvider.autoDispose.family<TodoObject, int>(
  (final ref, final id) async => TodoObject.fromMap(
    (await ref.read(dbProvider).getById(id: id)).first,
  ),
);
