import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './local_widgets/month_tasks_page/month_tasks_widget.dart';
import './local_widgets/months_tap_widget.dart';
import './local_widgets/search_widget.dart';
import '../../../../widgets/shared_axis_tabs.dart';

class HomeTab extends HookWidget {
  const HomeTab();

  @override
  Widget build(final context) {
    final currentMonth = DateTime.now().month - 1;

    final mainTabController = useTabController(
      initialLength: 12,
      initialIndex: currentMonth,
    );

    final scrollController = useScrollController(
      initialScrollOffset: (78.0 * currentMonth) + 19,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SearchWidget(),
        const SizedBox(height: 20),
        MonthsTapWidget(
          scrollController: scrollController,
          tabController: mainTabController,
        ),
        const SizedBox(height: 30),
        Expanded(
          child: SharedAxisTabs(
            mainTabController: mainTabController,
            tabs: tabs,
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  static final tabs = List.generate(
    12,
    (final index) => MonthTasksWidget(index: index, key: Key('$index')),
  );
}
