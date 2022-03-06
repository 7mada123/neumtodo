import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './local_widgets/timeline_todo_widget.dart';
import '../../repository/const_values.dart';
import '../../repository/riverpod_context_operations.dart';
import '../../widgets/appbar/appbar.dart';
import '../../widgets/neumorphism_widgets.dart';
import '../main_screen/tabs/home_tab/providers/day_provider.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen();

  @override
  Widget build(final context) {
    final theme = Theme.of(context), monthes = 'monthes'.tr().split(',');

    final provider =
        ModalRoute.of(context)!.settings.arguments as TodoDayProvider;

    final providerNotifier = context.read(provider.notifier);

    return Scaffold(
      appBar: AppBarWidget(text: 'timeline'.tr()),
      body: Padding(
        padding: paddingH20,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${providerNotifier.day} ${monthes[providerNotifier.month]}',
                  style: theme.textTheme.headline1,
                ),
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: NeumorphismButton(
                    padding: paddingH20V10,
                    onTap: () => Navigator.pushNamed(
                      context,
                      'AddEditScreen',
                    ),
                    child: Text(
                      'add_new'.tr(),
                      style: theme.textTheme.headline2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer(
                builder: (final context, final ref, final child) {
                  return ref.watch(provider).when(
                        errorCall: () => ref.refresh(provider),
                        onData: (final list, final context) {
                          return ListView.separated(
                            itemCount: 24,
                            padding: paddingH20V20,
                            separatorBuilder: (final context, final index) {
                              final values = list.where(
                                (final e) => e.shouldCompleteDate.hour == index,
                              );

                              if (values.isEmpty)
                                return const SizedBox(height: 50);

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: values
                                    .map(
                                      (final e) => TimelineTodoWidget(
                                        todo: e,
                                        provider: provider,
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                            itemBuilder: (final context, final index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_getTime(index)),
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        start: 20,
                                      ),
                                      child: Divider(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _getTime(final int index) {
    return _hoursString[index] + (index > 11 ? "pm".tr() : "am".tr());
  }

  static const _hoursString = [
    '12:00 ',
    '01:00 ',
    '02:00 ',
    '03:00 ',
    '04:00 ',
    '05:00 ',
    '06:00 ',
    '07:00 ',
    '08:00 ',
    '09:00 ',
    '10:00 ',
    '11:00 ',
    '12:00 ',
    '01:00 ',
    '02:00 ',
    '03:00 ',
    '04:00 ',
    '05:00 ',
    '06:00 ',
    '07:00 ',
    '08:00 ',
    '09:00 ',
    '10:00 ',
    '11:00 ',
  ];
}
