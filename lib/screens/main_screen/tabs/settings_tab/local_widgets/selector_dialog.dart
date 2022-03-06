import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../repository/const_values.dart';
import '../../../../../widgets/neumorphism_widgets.dart';

class SelectorDialog extends StatelessWidget {
  final List<String> list;
  final void Function(int index) onSelect;
  const SelectorDialog({
    required final this.list,
    required final this.onSelect,
  });

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < list.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: NeumorphismButton(
              padding: paddingH20V10,
              onTap: () {
                onSelect(i);
                Navigator.pop(context);
              },
              child: Text(
                list[i],
                style: theme.textTheme.headline6,
              ),
            ),
          ),
        const SizedBox(height: 30),
        NeumorphismButton(
          padding: paddingH20V10,
          onTap: () => Navigator.pop(context),
          child: Text(
            'cancel'.tr(),
            style: theme.textTheme.headline6!.copyWith(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
