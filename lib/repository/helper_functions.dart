import 'package:easy_localization/easy_localization.dart';

/// get animation (0.0 - 1.0) for every elment
double getElmentAnimation(final int i, final double animationValue) {
  return (i < animationValue
          ? 1 - (animationValue - i)
          : i > animationValue
              ? 1 + (animationValue - i)
              : 1.0)
      .clamp(0.0, 1.0);
}

extension DateTimeStringFormat on DateTime {
  String formatStringWithTime() {
    final isAM = hour <= 12;

    return '$year/$month/$day  ${isAM ? hour : hour - 12} : $minute ${isAM ? "am".tr() : "pm".tr()}';
  }

  String formatString() => '$year/$month/$day';
}
