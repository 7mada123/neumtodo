import 'package:flutter/material.dart';

import '../../../repository/const_values.dart';
import '../../../repository/helper_functions.dart';
import '../../../repository/riverpod_context_operations.dart';
import '../../../repository/todo_object.dart';
import '../../../widgets/custoum_popup_menu.dart';
import '../../../widgets/neumorphism_widgets.dart';
import '../../search_screen/provider/search_provider.dart';

class TimelineTodoWidget extends StatelessWidget {
  final TodoObject todo;
  final TodoListProvider provider;
  final bool showChecker;

  const TimelineTodoWidget({
    final Key? key,
    required this.todo,
    required this.provider,
    this.showChecker = true,
  }) : super(key: key);

  @override
  Widget build(final context) {
    final size = MediaQuery.of(context).size, theme = Theme.of(context);

    return Padding(
      padding: paddingV20,
      child: Row(
        mainAxisAlignment: showChecker
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (showChecker)
            SizedBox(
              width: size.width * 0.1,
              child: AnimatedSwitcher(
                duration: kThemeAnimationDuration,
                child: todo.isCompleted
                    ? const Icon(Icons.check_circle_outline)
                    : const SizedBox(width: 20),
              ),
            ),
          TappableNeumorphismWidget(
            width: size.width * 0.7,
            padding: paddingH20V20,
            alignment: Alignment.center,
            isTapped: todo.isCompleted,
            onTap: () => context.read(provider.notifier).switchDoneState(todo),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: kThemeAnimationDuration,
                        style: theme.textTheme.headline6!.copyWith(
                          color: todo.isCompleted
                              ? theme.scaffoldBackgroundColor
                              : null,
                        ),
                        child: Text(todo.title),
                      ),
                      const SizedBox(height: 10),
                      AnimatedDefaultTextStyle(
                        duration: kThemeAnimationDuration,
                        style: theme.textTheme.subtitle1!.copyWith(
                          color: todo.isCompleted
                              ? theme.scaffoldBackgroundColor
                              : null,
                        ),
                        child: Text(todo.description),
                      ),
                      if (!showChecker)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: AnimatedDefaultTextStyle(
                            duration: kThemeAnimationDuration,
                            style: theme.textTheme.headline6!.copyWith(
                              color: todo.isCompleted
                                  ? theme.scaffoldBackgroundColor
                                  : null,
                            ),
                            child: Text(
                              todo.shouldCompleteDate.formatStringWithTime(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Builder(
                  builder: (final context) => IconButton(
                    onPressed: () => onTap(context),
                    color: todo.isCompleted
                        ? theme.scaffoldBackgroundColor
                        : theme.primaryColor,
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTap(final BuildContext context) {
    showPopupMenu(
      context,
      onEditTap: () {
        context.read(provider.notifier).edit(todo);
      },
      onDeleteTap: () {
        context.read(provider.notifier).delete(todo);
      },
    );
  }
}
