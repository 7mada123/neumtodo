import 'package:flutter/material.dart';

class AndroidAppBar extends StatelessWidget {
  const AndroidAppBar(this.text);
  final String? text;

  @override
  Widget build(final context) {
    final topPadding = MediaQuery.of(context).padding.top + 10;

    if (ModalRoute.of(context)!.settings.name == '/')
      return SizedBox(height: topPadding);

    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: 10, right: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          if (text != null) ...[
            Expanded(
              child: Text(
                text!,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 32),
          ],
        ],
      ),
    );
  }
}
