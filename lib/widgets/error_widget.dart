import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import './neumorphism_widgets.dart';
import '../repository/const_values.dart';

class OnErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback callback;
  const OnErrorWidget({required this.error, required this.callback});

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getErrorMessage(error),
          style: theme.textTheme.headline4,
        ),
        const SizedBox(height: 20),
        NeumorphismButton(
          onTap: callback,
          padding: paddingH20V20,
          child: Text(
            'retry'.tr(),
            style: theme.textTheme.headline2,
          ),
        ),
      ],
    );
  }

  static String _getErrorMessage(final Object e) {
    if (e is SocketException)
      return 'connection_error'.tr();
    else if (e is HttpException)
      return e.message;
    else
      return e.toString();
  }
}
