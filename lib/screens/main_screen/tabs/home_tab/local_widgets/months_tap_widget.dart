import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../repository/const_values.dart';
import '../../../../../repository/helper_functions.dart';

class MonthsTapWidget extends StatelessWidget {
  final TabController tabController;
  final ScrollController scrollController;

  const MonthsTapWidget({
    required final this.tabController,
    required final this.scrollController,
  });

  double get animationValue => tabController.animation!.value;

  @override
  Widget build(final context) {
    final theme = Theme.of(context), monthes = 'monthes'.tr().split(',');

    final texts = List<Text>.from(monthes.map((final e) => Text(
          e,
          textScaleFactor: 1.0,
        )));

    return RepaintBoundary(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        child: AnimatedBuilder(
          animation: tabController.animation!,
          builder: (final context, final child) => Column(
            children: [
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < monthes.length; i++)
                    SizedBox(
                      width: 78,
                      child: TextButton(
                        onPressed: () {
                          tabController.animateTo(
                            i,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn,
                          );
                        },
                        child: DefaultTextStyle(
                          style: TextStyle.lerp(
                            theme.textTheme.subtitle2!,
                            theme.textTheme.subtitle1!,
                            getElmentAnimation(i, animationValue),
                          )!,
                          textAlign: TextAlign.center,
                          child: texts[i],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: _totalWidth,
                child: Align(
                  alignment: AlignmentDirectional.lerp(
                    AlignmentDirectional.bottomStart,
                    AlignmentDirectional.bottomEnd,
                    (animationValue / 11),
                  )!,
                  child: child!,
                ),
              ),
            ],
          ),
          child: SizedBox(
            width: 70,
            child: Align(
              child: Container(
                height: 0.7,
                width: 15,
                decoration: BoxDecoration(
                  color: theme.textTheme.subtitle1!.color,
                  borderRadius: borderRadius5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// tab width 78.0
  static const _totalWidth = 78.0 * 12;
}
