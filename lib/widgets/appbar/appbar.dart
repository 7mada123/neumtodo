import 'dart:io';

import 'package:flutter/material.dart';

import './android.dart';
import './windows.dart';

class AppBarWidget extends PreferredSize {
  final String? text;

  AppBarWidget({this.text})
      : super(
          child: Platform.isAndroid ? AndroidAppBar(text) : WindowsBar(text),
          preferredSize: _size,
        );

  static const _size = Size(double.infinity, 70);
}
