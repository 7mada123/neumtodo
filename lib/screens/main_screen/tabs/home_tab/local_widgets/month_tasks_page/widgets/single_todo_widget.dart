import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../repository/const_values.dart';
import '../../../../../../../repository/helper_functions.dart';
import '../../../../../../../repository/todo_object.dart';
import '../../../../../../../widgets/neumorphism_widgets.dart';
import '../../../providers/day_provider.dart';

class SingleTodoWidget extends ConsumerWidget {
  const SingleTodoWidget(this.provider, this.data);

  final TodoDayProvider provider;
  final List<TodoObject> data;

  @override
  Widget build(final context, final ref) {
    final theme = Theme.of(context), size = MediaQuery.of(context).size;

    final index = ref.watch(
      provider.select((final value) => value.selectedIndex),
    );

    if (data.isEmpty || index > data.length - 1)
      return const Center(
        child: CircularProgressIndicator(),
      );

    return Column(
      children: [
        const SizedBox(height: 61),
        Padding(
          padding: paddingH15,
          child: Text(' ', style: theme.textTheme.headline4),
        ),
        Flexible(
          child: AnimatedSwitcher(
            duration: kThemeChangeDuration,
            transitionBuilder: (final child, final animation) {
              return FadeScaleTransition(
                animation: animation,
                child: child,
              );
            },
            child: NeumorphismWidget(
              key: Key(index.toString()),
              width: size.width,
              child: Padding(
                padding: paddingH20V20,
                child: Column(
                  children: [
                    Text(
                      data[index].title,
                      style: theme.textTheme.headline4!,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data[index].description,
                      style: theme.textTheme.headline5!,
                    ),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: kThemeChangeDuration,
                      child: data[index].isCompleted
                          ? Text(
                              'done'.tr(),
                              style: theme.textTheme.headline5,
                            )
                          : const SizedBox(width: 40),
                    ),
                    Text(data[index].shouldCompleteDate.formatStringWithTime())
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
