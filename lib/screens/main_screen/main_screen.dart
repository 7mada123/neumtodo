import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './local_widgets/bottom_bar_widget.dart';
import './tabs/home_tab/home_tab.dart';
import './tabs/settings_tab/settings_tab.dart';
import '../../repository/const_values.dart';
import '../../widgets/appbar/appbar.dart';
import '../../widgets/custoum_dialog.dart';
import '../../widgets/shared_axis_tabs.dart';

class MainScreen extends HookWidget {
  const MainScreen();

  @override
  Widget build(final context) {
    final TabController mainTabController = useTabController(
      initialLength: 2,
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: paddingH20,
              child: SharedAxisTabs(
                mainTabController: mainTabController,
                tabs: _tabs,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomBar(mainTabController),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final isCancle = await showCancleDialog('close_app_dialog'.tr());

    if (isCancle) return false;

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');

    return false;
  }

  static const _tabs = [
    HomeTab(),
    SettingsTab(),
  ];
}
