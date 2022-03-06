import 'package:flutter/material.dart';

import '../../root_app.dart';

class SnackBarHelper {
  const SnackBarHelper();

  static void show({
    required final String message,
    final VoidCallback? onRetry,
    final SnackType type = SnackType.info,
    final bool maxDuration = false,
  }) {
    final theme = Theme.of(router.context);

    scaffoldMessengerKey.currentState!.clearSnackBars();
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: maxDuration
            ? const Duration(minutes: 2)
            : const Duration(seconds: 4),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          textScaleFactor: 1.0,
          style: TextStyle(
            color: type == SnackType.info ? theme.primaryColor : Colors.white,
          ),
        ),
        backgroundColor: type == SnackType.error
            ? Colors.red
            : type == SnackType.success
                ? Colors.green
                : theme.scaffoldBackgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void hide() {
    scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  }
}

enum SnackType {
  error,
  success,
  info,
}
