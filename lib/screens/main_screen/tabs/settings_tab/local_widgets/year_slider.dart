import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../repository/riverpod_context_operations.dart';
import '../../home_tab/providers/month_year_provider.dart';

class YearSlider extends StatefulWidget {
  const YearSlider();

  @override
  State<YearSlider> createState() => _YearSliderState();
}

class _YearSliderState extends State<YearSlider> {
  late double selectedYear = context.read(monthYearProvider).year.toDouble();

  String get lable => selectedYear.toStringAsFixed(0);

  @override
  Widget build(final context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'selected_year'.tr() + '  $lable',
          style: Theme.of(context).textTheme.headline2,
        ),
        Slider(
          value: selectedYear,
          divisions: 10,
          label: lable,
          max: currentYear + 5,
          min: currentYear - 5,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void onChanged(final double value) {
    setState(() => selectedYear = value);
    context.read(monthYearProvider).setTime(year: value.toInt());
  }

  static final currentYear = DateTime.now().year;
}
