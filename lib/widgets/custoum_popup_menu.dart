import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import './neumorphism_widgets.dart';
import '../repository/const_values.dart';

void showPopupMenu(
  final BuildContext context, {
  required final VoidCallback onEditTap,
  required final VoidCallback onDeleteTap,
}) async {
  final offset = (context.findRenderObject() as RenderBox).localToGlobal(
    Offset.zero,
  );

  final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

  final theme = Theme.of(context);

  await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      offset & const Size(100, 100),
      Offset.zero & overlay.size,
    ),
    shape: shapeBorderRadius10,
    color: theme.scaffoldBackgroundColor,
    elevation: 8.0,
    items: [
      PopupMenuItem(
        value: 0,
        padding: paddingV10,
        enabled: false,
        child: Align(
          child: NeumorphismButton(
            onTap: () => Navigator.pop(context, 0),
            padding: paddingH20V10,
            child: Text(
              "edit".tr(),
              style: theme.textTheme.headline2,
            ),
          ),
        ),
      ),
      PopupMenuItem(
        value: 0,
        padding: paddingV10,
        enabled: false,
        child: Align(
          child: NeumorphismButton(
            onTap: () => Navigator.pop(context, 1),
            padding: paddingH20V10,
            child: Text(
              "delete".tr(),
              style: theme.textTheme.headline2,
            ),
          ),
        ),
      ),
    ],
  ).then((final value) {
    if (value == null) return;

    if (value == 0)
      onEditTap();
    else
      onDeleteTap();
  });
}
