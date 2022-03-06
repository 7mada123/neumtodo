import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisTabs extends StatelessWidget {
  const SharedAxisTabs({
    required this.mainTabController,
    required this.tabs,
  });

  final TabController mainTabController;
  final List<Widget> tabs;

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: mainTabController,
        builder: (final context, final _) {
          return PageTransitionSwitcher(
            child: tabs[mainTabController.index],
            duration: kTabScrollDuration * 2,
            reverse: mainTabController.previousIndex > mainTabController.index,
            transitionBuilder: (
              final child,
              final primaryAnimation,
              final secondaryAnimation,
            ) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: theme.scaffoldBackgroundColor,
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
