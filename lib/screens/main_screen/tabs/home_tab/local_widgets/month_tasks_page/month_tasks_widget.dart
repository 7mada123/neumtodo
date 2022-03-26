import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './widgets/page_widget.dart';
import '../../../../../../repository/const_values.dart';
import '../../../../../../repository/helper_functions.dart';
import '../../providers/day_provider.dart';
import '../../providers/month_provider.dart';

class MonthTasksWidget extends ConsumerStatefulWidget {
  const MonthTasksWidget({
    required final this.index,
    required final Key key,
  }) : super(key: key);

  final int index;

  @override
  _DaysWidgetState createState() => _DaysWidgetState();
}

class _DaysWidgetState extends ConsumerState<MonthTasksWidget> {
  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    final isloading = ref.watch(
      monthDaysListProvider(widget.index).select(
        (final value) => value.isLoading,
      ),
    );

    if (isloading)
      return const Center(
        child: CircularProgressIndicator(),
      );

    final daysList = ref.watch(
      monthDaysListProvider(widget.index).select(
        (final value) => value.daysList,
      ),
    );

    if (page > 0.0 && page.round() > daysList.length - 1) {
      pageController.jumpToPage(daysList.length - 1);
    }

    if (daysList.isEmpty)
      return Center(
        child: Text(
          'no_tasks'.tr(),
          style: theme.textTheme.headline5,
        ),
      );

    final boxShadow = [
      BoxShadow(
        color: theme.colorScheme.background,
        offset: positiveOffset,
        blurRadius: 6,
      ),
      BoxShadow(
        color: theme.colorScheme.secondary,
        offset: negativeOffset,
        blurRadius: 6,
      ),
    ];

    final texts = List<Text>.from(daysList.map((final e) => Text(
          e.day.toString(),
          textScaleFactor: 1.0,
        )));

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: AnimatedBuilder(
            animation: pageController,
            builder: (final context, final child) => ListView.builder(
              clipBehavior: Clip.none,
              itemCount: daysList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (final context, final i) {
                final animationValue = getElmentAnimation(i, page);
                final color = Color.lerp(
                  theme.primaryColor,
                  theme.colorScheme.secondary,
                  animationValue,
                )!;

                return Padding(
                  padding: paddingH10,
                  child: GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(
                              color: color,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                            child: texts[i],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              daysList[i].count <= 3 ? daysList[i].count : 4,
                              (final _) => Container(
                                height: 5,
                                width: 5,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          theme.scaffoldBackgroundColor,
                          theme.primaryColor,
                          animationValue,
                        )!,
                        borderRadius: borderRadius10,
                        boxShadow: boxShadow,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            clipBehavior: Clip.none,
            allowImplicitScrolling: true,
            controller: pageController,
            itemBuilder: (final context, final index) => TodoDayPage(
              todoDayProvider: todoDayProvider(daysList[index].day),
            ),
            itemCount: daysList.length,
          ),
        ),
      ],
    );
  }

  double page = 0.0;

  late final PageController pageController = PageController(
    viewportFraction: 1.1,
    initialPage: page.round(),
  );

  @override
  void initState() {
    super.initState();

    page = 0;

    pageController.addListener(pageControllerListener);
  }

  @override
  void dispose() {
    super.dispose();

    pageController.removeListener(pageControllerListener);

    pageController.dispose();
  }

  void pageControllerListener() {
    page = pageController.page!;
  }
}
