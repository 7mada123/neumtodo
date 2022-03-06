import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './list_wdget.dart';
import './single_todo_widget.dart';
import '../../../providers/day_provider.dart';

class TodoDayPage extends ConsumerWidget {
  const TodoDayPage({
    final Key? key,
    required this.todoDayProvider,
  }) : super(key: key);

  final TodoDayProvider todoDayProvider;

  @override
  Widget build(final context, final ref) {
    final providerNotifier = ref.read(todoDayProvider.notifier),
        width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
      child: ref.watch(todoDayProvider).when(
            errorCall: () => ref.refresh(todoDayProvider),
            onData: (final data, final context) {
              if (width > 750)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ListWdget(
                        providerNotifier,
                        data,
                        todoDayProvider,
                      ),
                    ),
                    const SizedBox(width: 50),
                    Flexible(
                      child: SingleTodoWidget(todoDayProvider, data),
                    ),
                  ],
                );
              else
                return ListWdget(providerNotifier, data, todoDayProvider);
            },
          ),
    );
  }
}
