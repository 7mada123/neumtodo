import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import './checkbox_todo_title.dart';
import '../../../../../../../repository/const_values.dart';
import '../../../../../../../repository/todo_object.dart';
import '../../../../../../../widgets/neumorphism_widgets.dart';
import '../../../providers/day_provider.dart';

class ListWdget extends StatelessWidget {
  const ListWdget(this.providerNotifier, this.data, this.todoDayProvider);

  final DayListProvider providerNotifier;
  final List<TodoObject> data;
  final TodoDayProvider todoDayProvider;

  @override
  Widget build(final context) {
    final size = MediaQuery.of(context).size, theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 35),
        Padding(
          padding: paddingH15,
          child: Text(
            _dayText(data.first.shouldCompleteDate),
            style: theme.textTheme.headline4,
          ),
        ),
        const SizedBox(height: 26),
        Flexible(
          child: NeumorphismWidget(
            width: size.width,
            child: Padding(
              padding: paddingH20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${data.length} ${data.length > 1 ? "tasks".tr() : "task".tr()}',
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final todo in data)
                            CheckBoxTodoTitle(
                              data: todo,
                              provider: todoDayProvider,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 10),
                  ListTile(
                    title: Text(
                      "to_timeline".tr(),
                      style: theme.textTheme.headline4,
                    ),
                    shape: shapeBorderRadius10,
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: theme.primaryColor,
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      'TimelineScreen',
                      arguments: todoDayProvider,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _dayText(final DateTime date) {
    final todayDate = DateTime.now();

    if (todayDate.year == date.year && todayDate.month == date.month) {
      if (todayDate.day == date.day)
        return "today".tr();
      else if (todayDate.day + 1 == date.day) return "tomorrow".tr();
    }

    return '${date.day} ${"monthes".tr().split(',')[date.month - 1]}';
  }
}
