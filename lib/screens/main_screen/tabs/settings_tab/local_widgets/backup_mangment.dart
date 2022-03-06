import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../repository/const_values.dart';
import '../../../../../repository/helper_functions.dart';
import '../../../../../widgets/custoum_dialog.dart';
import '../../../../../widgets/error_widget.dart';
import '../../../../../widgets/neumorphism_widgets.dart';
import '../providers/google_oauth_client.dart';

class BackupManagement extends StatelessWidget {
  const BackupManagement();

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return NeumorphismButton(
      padding: paddingH20V10,
      child: Text(
        'backup_anagement'.tr(),
        style: theme.textTheme.headline2,
      ),
      onTap: () => showCustoumDialog(
        Consumer(
          builder: (final context, final ref, final child) {
            return ref.watch(backupListProvider).when(
                  data: (final data) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final val in data.entries)
                        Padding(
                          padding: paddingV10,
                          child: NeumorphismButton(
                            padding: paddingH20V10,
                            child: Text(
                              val.value.toLocal().formatStringWithTime(),
                              style: theme.textTheme.headline2,
                            ),
                            onTap: () {
                              showCustoumDialog(
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    NeumorphismButton(
                                      padding: paddingH20V10,
                                      child: Text(
                                        'Backup_recovery'.tr(),
                                        style: theme.textTheme.headline2,
                                      ),
                                      onTap: () {
                                        ref
                                            .read(googleOAuthProvider)
                                            .retriveBackUp(
                                              val.key,
                                              val.value,
                                            );

                                        while (Navigator.canPop(context))
                                          Navigator.pop(context);
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    NeumorphismButton(
                                      padding: paddingH20V10,
                                      child: Text(
                                        'delete_backup'.tr(),
                                        style:
                                            theme.textTheme.headline2!.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onTap: () {
                                        ref
                                            .read(googleOAuthProvider)
                                            .deleteBackUp(val.key);

                                        while (Navigator.canPop(context))
                                          Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  error: (final error, final stack) {
                    return OnErrorWidget(
                      error: error,
                      callback: () => ref.refresh(backupListProvider),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
          },
        ),
      ),
    );
  }
}
