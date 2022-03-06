import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void setEnabledSystemUIMode(final bool isFullScreen) {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: isFullScreen ? const [] : SystemUiOverlay.values,
  );
}

void setAppbarBottombarTheme({final int index = 0}) {
  late final Brightness brightness = index.getBrightness();

  final isDarkMode = brightness == Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ).copyWith(
      systemNavigationBarColor:
          isDarkMode ? const Color(0xFFF0F3F6) : const Color(0xFF212121),
      statusBarIconBrightness: brightness,
      systemNavigationBarIconBrightness: brightness,
    ),
  );
}

extension on int {
  Brightness getBrightness() {
    switch (this) {
      case 1:
        return Brightness.dark;
      case 2:
        return Brightness.light;
      default:
        return SchedulerBinding.instance!.window.platformBrightness ==
                Brightness.dark
            ? Brightness.light
            : Brightness.dark;
    }
  }
}
