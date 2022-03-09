import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import './local_widgets/backup_mangment.dart';
import './local_widgets/selector_dialog.dart';
import './local_widgets/year_slider.dart';
import './providers/google_oauth_client.dart';
import './providers/setting_data.dart';
import '../../../../../repository/const_values.dart';
import '../../../../../repository/riverpod_context_operations.dart';
import '../../../../../repository/theme_manger.dart';
import '../../../../widgets/custoum_dialog.dart';
import '../../../../widgets/neumorphism_widgets.dart';

class SettingsTab extends HookConsumerWidget {
  const SettingsTab();

  @override
  Widget build(final context, final ref) {
    final theme = Theme.of(context);

    final useFullScreen = useValueNotifier<bool>(
      ref.read(settingsDataProvider).ioData.fullScreenMode,
    );

    final languesList = 'language_list'.tr().split(',');
    final themeList = 'theme_list'.tr().split(',');

    final isNotLogin = ref.watch(googleOAuthProvider).isNotLogin;

    void changeScreenMode([final bool? mm]) {
      final newVal = !useFullScreen.value;

      useFullScreen.value = newVal;
      ref.read(settingsDataProvider).setfullScreenMode(newVal);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        padding: paddingH20V20,
        child: Align(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeumorphismButton(
                padding: paddingH20V20,
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      'language'.tr(),
                      style: theme.textTheme.headline2,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: theme.primaryColor,
                    ),
                  ],
                ),
                onTap: () {
                  showCustoumDialog(
                    SelectorDialog(
                      list: languesList,
                      onSelect: (final index) {
                        if (index == 0) {
                          try {
                            context.setLocale(
                              Locale(context.deviceLocale.languageCode),
                            );
                          } catch (e) {
                            context.setLocale(languseLocal[0]);
                          }

                          context.deleteSaveLocale();
                        } else {
                          context.setLocale(languseLocal[index - 1]);
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              NeumorphismButton(
                padding: paddingH20V20,
                child: Row(
                  children: [
                    Icon(
                      Icons.color_lens_outlined,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      'theme'.tr(),
                      style: theme.textTheme.headline2,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: theme.primaryColor,
                    ),
                  ],
                ),
                onTap: () {
                  showCustoumDialog(
                    SelectorDialog(
                      list: themeList,
                      onSelect: (final index) {
                        context
                            .read(themeModeProvider.notifier)
                            .changeThemeMode(
                              index,
                            );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              if (Platform.isAndroid)
                NeumorphismButton(
                  padding: paddingH20V10.copyWith(bottom: 40),
                  onTap: changeScreenMode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'full_screen'.tr(),
                        style: theme.textTheme.headline2,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: useFullScreen,
                        builder: (final context, final value, final child) {
                          return Switch(
                            value: value,
                            activeColor: theme.primaryColor,
                            onChanged: changeScreenMode,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              const YearSlider(),
              const SizedBox(height: 30),
              if (isNotLogin) ...[
                Text(
                  'Sign_backup'.tr(),
                  style: theme.textTheme.headline2,
                ),
                const SizedBox(height: 20),
                NeumorphismButton(
                  padding: paddingH20V10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'googleSing'.tr(),
                        style: theme.textTheme.headline2,
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.launch),
                    ],
                  ),
                  onTap: () {
                    context.read(googleOAuthProvider.notifier).logIn();
                  },
                ),
              ] else
                Wrap(
                  runSpacing: 30,
                  spacing: MediaQuery.of(context).size.width * 0.2,
                  children: [
                    const BackupManagement(),
                    NeumorphismButton(
                      padding: paddingH20V10,
                      child: Text(
                        'backup_now'.tr(),
                        style: theme.textTheme.headline2,
                      ),
                      onTap: () {
                        context.read(googleOAuthProvider.notifier).backup(
                              showSnackBar: true,
                            );
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 50),
              Wrap(
                runSpacing: 30,
                spacing: MediaQuery.of(context).size.width * 0.2,
                children: [
                  NeumorphismButton(
                    padding: paddingH20V10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Platform.isAndroid ? 'Windows' : 'Android',
                          style: theme.textTheme.headline2,
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.launch),
                      ],
                    ),
                    onTap: () {
                      if (Platform.isAndroid)
                        // TODO
                        launch('');
                      else
                        launch(
                          'https://play.google.com/store/apps/details?id=com.hamada.neumtodo',
                        );
                    },
                  ),
                  NeumorphismButton(
                    padding: paddingH20V10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'GitHub',
                          style: theme.textTheme.headline2,
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.launch),
                      ],
                    ),
                    onTap: () {
                      launch('https://github.com/7mada123/neumtodo');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  static const languseLocal = [
    Locale('en'),
    Locale('ar'),
  ];
}
