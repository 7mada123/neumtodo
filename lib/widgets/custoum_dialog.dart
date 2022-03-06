import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../repository/const_values.dart';
import '../root_app.dart';
import 'neumorphism_widgets.dart';

Future<dynamic> showCustoumDialog(final Widget child) {
  return showModal(
    context: router.context,
    configuration: _configuration,
    builder: (final context) => DialogWidget(child: child),
  );
}

class DialogWidget extends StatelessWidget {
  final Widget child;
  const DialogWidget({required final this.child});

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return Align(
      child: SizedBox(
        width: 300,
        child: Material(
          shape: shapeBorderRadius10,
          color: theme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Return bool
///
/// false on yes and true on cancle
Future<bool> showCancleDialog(final String warning) async {
  return await showModal<bool>(
        context: router.context,
        configuration: _configuration,
        builder: (final context) => _CancleDialog(warning),
      ) ??
      true;
}

class _CancleDialog extends StatelessWidget {
  final String warning;
  const _CancleDialog(this.warning);

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return DialogWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            warning,
            style: theme.textTheme.headline2,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeumorphismButton(
                onTap: () => Navigator.pop(context, true),
                padding: paddingH20V10,
                child: Text(
                  "cancel".tr(),
                  style: theme.textTheme.headline2,
                ),
              ),
              NeumorphismButton(
                onTap: () => Navigator.pop(context, false),
                padding: paddingH20V10,
                child: Text(
                  "yes".tr(),
                  style: theme.textTheme.headline2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _configuration = FadeScaleTransitionConfiguration(
  transitionDuration: kThemeChangeDuration,
  reverseTransitionDuration: kThemeChangeDuration,
);
