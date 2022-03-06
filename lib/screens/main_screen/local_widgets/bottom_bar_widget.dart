import 'package:flutter/material.dart';

import '../../../../repository/const_values.dart';
import '../../../repository/helper_functions.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(this.tabController);

  final TabController tabController;

  double get animationValue => tabController.animation!.value;

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Divider(height: 0),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: theme.scaffoldBackgroundColor,
              child: SizedBox(
                height: 65,
                child: Padding(
                  padding: paddingH20,
                  child: AnimatedBuilder(
                    animation: tabController.animation!,
                    builder: (final context, final child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => tabController.animateTo(0),
                          color: Color.lerp(
                            theme.primaryColor.withOpacity(0.3),
                            theme.primaryColor,
                            getElmentAnimation(0, animationValue),
                          )!,
                          icon: const Icon(Icons.menu),
                        ),
                        IconButton(
                          onPressed: () => tabController.animateTo(1),
                          color: Color.lerp(
                            theme.primaryColor.withOpacity(0.3),
                            theme.primaryColor,
                            getElmentAnimation(1, animationValue),
                          )!,
                          icon: const Icon(Icons.settings_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'AddEditScreen'),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: borderRadius15,
                  color: theme.primaryColor,
                ),
                child: Icon(
                  Icons.add,
                  color: theme.scaffoldBackgroundColor,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
