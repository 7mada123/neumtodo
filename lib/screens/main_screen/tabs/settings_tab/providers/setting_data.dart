import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../repository/io_data_class.dart';
import '../../../../../repository/system_bars.dart';

final settingsDataProvider = Provider<UserSettingsProvider>((final ref) {
  throw UnimplementedError();
});

class UserSettingsProvider extends ChangeNotifier
    with IODataClass<SettingsData> {
  final String _path;

  static const _fileName = 'settings_data.json';

  UserSettingsProvider(this._path) {
    ioInitData(_path, _fileName);
    setEnabledSystemUIMode(ioData.fullScreenMode);
  }

  void setThemeMode(final int index) async {
    ioData = ioData.copyWith(theme: index);
    ioSaveData();
  }

  void setfullScreenMode(final bool value) async {
    setEnabledSystemUIMode(value);
    ioData = ioData.copyWith(fullScreenMode: value);
    ioSaveData();
    notifyListeners();
  }

  @override
  SettingsData fromMap(final value) => SettingsData.fromMap(value);

  @override
  SettingsData initValue() => SettingsData.init();

  @override
  String ioDataToJson() => encode(ioData.toMap());
}

class SettingsData {
  final int theme;
  final bool fullScreenMode;

  const SettingsData({
    required final this.theme,
    required final this.fullScreenMode,
  });

  SettingsData.init()
      : fullScreenMode = false,
        theme = 0;

  SettingsData copyWith({
    final int? theme,
    final bool? fullScreenMode,
  }) {
    return SettingsData(
      theme: theme ?? this.theme,
      fullScreenMode: fullScreenMode ?? this.fullScreenMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'theme': theme,
      'fullScreenMode': fullScreenMode,
    };
  }

  factory SettingsData.fromMap(final Map<String, dynamic> map) {
    return SettingsData(
      theme: map['theme'] ?? 0,
      fullScreenMode: map['fullScreenMode'] ?? false,
    );
  }

  @override
  bool operator ==(final other) {
    if (identical(this, other)) return true;

    return other is SettingsData &&
        other.theme == theme &&
        other.fullScreenMode == fullScreenMode;
  }

  @override
  int get hashCode => theme.hashCode ^ fullScreenMode.hashCode;
}
