import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../repository/const_values.dart';
import '../../../repository/helper_functions.dart';
import '../../../repository/riverpod_context_operations.dart';
import '../../../widgets/neumorphism_widgets.dart';
import '../provider/search_helper.dart';
import '../provider/search_provider.dart';

void showSearchSettingsWidget(final BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (final context) => const _SearchSettings(),
  );
}

class _SearchSettings extends HookWidget {
  const _SearchSettings();

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    final todayDate = DateTime.now();

    SearchObject searchObject = TodoSearchProvider.searchData;

    final isCompletedOnly = useValueNotifier<bool>(
          searchObject.isCompetedOnly,
        ),
        date = useValueNotifier<DateTimeRange>(
          searchObject.date == null
              ? DateTimeRange(start: todayDate, end: todayDate)
              : searchObject.date!,
        );

    void switchIsCompeted(final bool value) {
      isCompletedOnly.value = value;

      searchObject = searchObject.copyWith(
        isCompetedOnly: value,
      );
    }

    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            NeumorphismButton(
              padding: paddingH20V10,
              onTap: () => switchIsCompeted(!isCompletedOnly.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'completed_only'.tr(),
                    style: theme.textTheme.headline2,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isCompletedOnly,
                    builder: (final context, final value, final child) {
                      return Switch(
                        value: value,
                        activeColor: theme.primaryColor,
                        onChanged: switchIsCompeted,
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: NeumorphismButton(
                padding: paddingH20V20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'date'.tr(),
                      style: theme.textTheme.headline2,
                    ),
                    ValueListenableBuilder<DateTimeRange>(
                      valueListenable: date,
                      builder: (final context, final value, final _) {
                        final showAll = value.start == value.end;

                        return Text(
                          showAll
                              ? 'all'.tr()
                              : '${value.start.formatString()} - ${value.end.formatString()}',
                          style: theme.textTheme.headline5,
                        );
                      },
                    ),
                  ],
                ),
                onTap: () async {
                  final selectedDate = await showDateRangePicker(
                    context: context,
                    initialDateRange: date.value,
                    firstDate: todayDate.subtract(twoYears),
                    lastDate: todayDate.add(twoYears),
                  );

                  if (selectedDate == null) return;

                  date.value = selectedDate;

                  searchObject = searchObject.copyWith(date: selectedDate);
                },
              ),
            ),
            Align(
              alignment: const Alignment(0.9, 0),
              child: NeumorphismButton(
                padding: paddingH20V10,
                onTap: () {
                  context
                      .read((todoSearchProvider).notifier)
                      .setSearchData(searchObject);

                  Navigator.pop(context);
                },
                child: Text(
                  'update'.tr(),
                  style: theme.textTheme.headline2,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
