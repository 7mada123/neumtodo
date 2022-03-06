import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './provider/single_todo_provider.dart';
import '../../repository/const_values.dart';
import '../../repository/db_provider.dart';
import '../../repository/helper_functions.dart';
import '../../repository/riverpod_context_operations.dart';
import '../../root_app.dart';
import '../../widgets/appbar/appbar.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/neumorphism_widgets.dart';
import '../main_screen/tabs/home_tab/providers/month_year_provider.dart';

class SingleTodoScreen extends ConsumerWidget {
  const SingleTodoScreen();

  @override
  Widget build(final context, final ref) {
    final size = MediaQuery.of(context).size, theme = Theme.of(context);

    final id = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBarWidget(),
      body: Align(
        child: Padding(
          padding: paddingH20,
          child: ref.watch(singleTodoProvider(id)).when(
                error: (final error, final stackTrace) => OnErrorWidget(
                  error: error,
                  callback: () => ref.refresh(singleTodoProvider(id)),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (final data) => NeumorphismWidget(
                  height: size.height * 0.8,
                  width: size.width * 0.8,
                  child: Padding(
                    padding: paddingH20V20,
                    child: Column(
                      children: [
                        Text(
                          data.title,
                          style: theme.textTheme.headline4!,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data.description,
                          style: theme.textTheme.headline5!,
                        ),
                        const Spacer(),
                        Wrap(
                          runSpacing: 30,
                          spacing: size.width * 0.2,
                          children: [
                            NeumorphismButton(
                              onTap: () {
                                ref
                                    .read(dbProvider)
                                    .edit(data.copyWith(isCompleted: true))
                                    .then(refreshUiData);

                                Navigator.pop(context);
                              },
                              padding: paddingH20V10,
                              child: Text(
                                "done".tr(),
                                style: theme.textTheme.headline2,
                              ),
                            ),
                            NeumorphismButton(
                              onTap: () {
                                ref
                                    .read(dbProvider)
                                    .delete(id)
                                    .then(refreshUiData);

                                Navigator.pop(context);
                              },
                              padding: paddingH20V10,
                              child: Text(
                                "delete".tr(),
                                style: theme.textTheme.headline2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        AnimatedSwitcher(
                          duration: kThemeChangeDuration,
                          child: data.isCompleted
                              ? Text(
                                  'done'.tr(),
                                  style: theme.textTheme.headline5,
                                )
                              : const SizedBox(width: 40),
                        ),
                        Text(
                          data.shouldCompleteDate.formatStringWithTime(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  static void refreshUiData(final int val) {
    router.context.read(monthYearProvider).refreshDisplayedData();
  }
}
