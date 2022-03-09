import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../repository/const_values.dart';
import '../../../../../../../repository/riverpod_context_operations.dart';
import '../../../../../../../repository/todo_object.dart';
import '../../../../../../../widgets/custoum_popup_menu.dart';
import '../../../providers/day_provider.dart';

class CheckBoxTodoTitle extends StatelessWidget {
  const CheckBoxTodoTitle({
    final Key? key,
    required this.data,
    required this.provider,
  }) : super(key: key);

  final TodoObject data;
  final TodoDayProvider provider;

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: borderRadius10,
      onTap: () {
        if (MediaQuery.of(context).size.width <= 750)
          context.read(provider.notifier).switchDoneState(data);
        else
          context.read(provider.notifier).setSelectIndex(data);
      },
      onLongPress: () => showPopupMenu(
        context,
        onEditTap: () => context.read(provider.notifier).edit(data),
        onDeleteTap: () => context.read(provider.notifier).delete(data),
      ),
      child: Padding(
        padding: paddingH20V10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: data.isCompleted,
              onChanged: (final _) {
                context.read(provider.notifier).switchDoneState(data);
              },
            ),
            Expanded(
              child: Text(
                data.title,
                style: theme.textTheme.headline4!.copyWith(
                  decoration:
                      data.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: kThemeChangeDuration,
              child: data.isCompleted
                  ? Text(
                      'done'.tr(),
                      style: theme.textTheme.headline5,
                    )
                  : const SizedBox(width: 40),
            ),
          ],
        ),
      ),
    );
  }
}
