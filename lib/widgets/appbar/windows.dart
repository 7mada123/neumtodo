import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../../repository/const_values.dart';

class WindowsBar extends StatelessWidget {
  const WindowsBar(this.text);
  final String? text;

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    final color = WindowButtonColors(
      normal: theme.scaffoldBackgroundColor,
      mouseDown: theme.primaryColor,
      iconMouseOver: theme.scaffoldBackgroundColor,
      mouseOver: theme.primaryColor,
      iconMouseDown: theme.scaffoldBackgroundColor,
      iconNormal: theme.primaryColor,
    );

    return PreferredSize(
      preferredSize: const Size(0, 70),
      child: SizedBox(
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MoveWindow(
                child: Row(
                  children: [
                    Padding(
                      padding: paddingH20V10,
                      child: ModalRoute.of(context)!.settings.name == '/'
                          ? Text(
                              'NEUMTODO',
                              style: theme.textTheme.headline2,
                            )
                          : IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back),
                            ),
                    ),
                    if (text != null)
                      Expanded(
                        child: Text(
                          text!,
                          style: theme.textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            MinimizeWindowButton(colors: color),
            MaximizeWindowButton(colors: color),
            CloseWindowButton(colors: color),
          ],
        ),
      ),
    );
  }
}
