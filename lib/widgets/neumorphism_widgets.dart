import 'package:flutter/material.dart';

import '../repository/const_values.dart';

class NeumorphismWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;

  const NeumorphismWidget({
    final Key? key,
    this.height,
    this.width,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: borderRadius10,
          boxShadow: [
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
          ],
        ),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }
}

class TappableNeumorphismWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final VoidCallback onTap;
  final bool isTapped;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;

  const TappableNeumorphismWidget({
    final Key? key,
    this.height,
    this.width,
    this.alignment,
    this.padding,
    required this.child,
    required this.onTap,
    required this.isTapped,
  }) : super(key: key);

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: borderRadius10,
      onTap: onTap,
      child: AnimatedContainer(
        duration: kThemeChangeDuration,
        height: height,
        width: width,
        child: child,
        padding: padding,
        alignment: alignment,
        decoration: BoxDecoration(
          color: isTapped ? theme.primaryColor : theme.scaffoldBackgroundColor,
          borderRadius: borderRadius10,
          boxShadow: isTapped
              ? const []
              : [
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
                ],
        ),
      ),
    );
  }
}

class NeumorphismButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets padding;

  const NeumorphismButton({
    final Key? key,
    required this.child,
    required this.onTap,
    required this.padding,
  }) : super(key: key);

  @override
  State<NeumorphismButton> createState() => _NeumorphismWidgeButton();
}

class _NeumorphismWidgeButton extends State<NeumorphismButton> {
  void changeIsTapped(final bool state) {
    if (mounted) setState(() => isTapped = state);
  }

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _handelOnTap,
      onTapDown: (final _) => changeIsTapped(true),
      onTapCancel: () => changeIsTapped(false),
      onTapUp: (final _) => changeIsTapped(false),
      child: AnimatedContainer(
        duration: kThemeChangeDuration,
        child: Padding(padding: widget.padding, child: widget.child),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: borderRadius10,
          boxShadow: [
            BoxShadow(
              blurStyle: isTapped ? BlurStyle.inner : BlurStyle.normal,
              color: theme.colorScheme.background,
              offset: isTapped ? negativeOffset : positiveOffset,
              blurRadius: 6,
            ),
            BoxShadow(
              blurStyle: isTapped ? BlurStyle.inner : BlurStyle.normal,
              color: theme.colorScheme.secondary,
              offset: isTapped ? positiveOffset : negativeOffset,
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }

  bool isTapped = false;

  Future<void> _handelOnTap() async {
    setState(() => isTapped = true);
    widget.onTap();
    await Future.delayed(kThemeChangeDuration);
    if (!mounted) return;
    setState(() => isTapped = false);
  }
}
