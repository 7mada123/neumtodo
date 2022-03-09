import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import './repository/db_provider.dart';
import './repository/drive_api_data.dart';
import './repository/notifications.dart';
import './repository/theme_manger.dart';
import './root_app.dart';
import './screens/main_screen/tabs/settings_tab/providers/google_oauth_client.dart';
import './screens/main_screen/tabs/settings_tab/providers/setting_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Notifications.init();

  ThemeManger.init();

  final dir = await getApplicationDocumentsDirectory();

  final db = TodosDb(dir.path);

  await db.init();

  await EasyLocalization.ensureInitialized();

  final credentials = await DriveApiData.getCredentials();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          googleOAuthProvider.overrideWithValue(
            GoogleAuthClient(dir.path, credentials),
          ),
          settingsDataProvider.overrideWithValue(
            UserSettingsProvider(dir.path),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );

  if (Platform.isAndroid) return;

  appWindow.minSize = const Size(460.8, 715.0);

  await windowManager.ensureInitialized();

  await windowManager.setTitleBarStyle('hidden');

  await windowManager.show();
}
