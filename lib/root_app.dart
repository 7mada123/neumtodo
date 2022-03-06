import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './repository/notifications.dart';
import './repository/riverpod_context_operations.dart';
import './repository/theme_manger.dart';
import './screens/add_edit_screen/add_edit_screen.dart';
import './screens/main_screen/main_screen.dart';
import './screens/main_screen/tabs/settings_tab/providers/google_oauth_client.dart';
import './screens/search_screen/search_screen.dart';
import './screens/single_todo_screen/single_todo_screen.dart';
import './screens/timeline_screen/timeline_screen.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    if (Platform.isAndroid) {
      _setOptimalDisplayMode();
      Notifications.getNotificationAppLaunchDetails();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final state) {
    if (state == AppLifecycleState.detached) {
      context.read(googleOAuthProvider.notifier).backup();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(final context) {
    return MaterialApp(
      title: 'NEUMTODO',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: _navigatorKey,
      routes: _routes,
      locale: context.locale,
      checkerboardOffscreenLayers: true,
      scrollBehavior: const _CustomScrollBehavior(),
      darkTheme: ThemeManger.darkTheme,
      theme: ThemeManger.lightTheme,
      themeMode: ref.watch(themeModeProvider),
    );
  }

  static final _routes = {
    "/": (final BuildContext ctx) => const MainScreen(),
    "AddEditScreen": (final BuildContext ctx) => const AddEditScreen(),
    "TimelineScreen": (final BuildContext ctx) => const TimelineScreen(),
    "SearchScreen": (final BuildContext ctx) => const SearchScreen(),
    "SingleTodoScreen": (final BuildContext ctx) => const SingleTodoScreen(),
  };
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final _navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get router => _navigatorKey.currentState!;

/// set fps to 120 on suported devices
Future<void> _setOptimalDisplayMode() async {
  final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  final DisplayMode active = await FlutterDisplayMode.active;

  final List<DisplayMode> sameResolution = supported
      .where((final m) => m.width == active.width && m.height == active.height)
      .toList(growable: false)
    ..sort((final a, final b) => b.refreshRate.compareTo(a.refreshRate));

  final DisplayMode mostOptimalMode =
      sameResolution.isNotEmpty ? sameResolution.first : active;

  await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}

/// Override behavior methods and getters like dragDevices
class _CustomScrollBehavior extends MaterialScrollBehavior {
  const _CustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
