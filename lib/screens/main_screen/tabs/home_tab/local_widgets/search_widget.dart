import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget();

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 51.0,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, 'SearchScreen'),
          child: Hero(
            tag: 'search_bar',
            child: Material(
              color: theme.backgroundColor,
              elevation: 5,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: theme.primaryColor,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'search'.tr(),
                      style: theme.textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
