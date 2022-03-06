import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './local_widgets/search_settings_bottom_sheet.dart';
import './provider/search_provider.dart';
import '../../repository/const_values.dart';
import '../../repository/riverpod_context_operations.dart';
import '../../root_app.dart';
import '../../widgets/appbar/appbar.dart';
import '../timeline_screen/local_widgets/timeline_todo_widget.dart';

class SearchScreen extends HookWidget {
  const SearchScreen();

  @override
  Widget build(final context) {
    final theme = Theme.of(context);

    final textController = useTextEditingController(
      text: TodoSearchProvider.searchData.searchText,
    );

    return Scaffold(
      appBar: AppBarWidget(text: 'search'.tr()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 51,
                      child: Hero(
                        tag: 'search_bar',
                        child: Material(
                          elevation: 5,
                          shadowColor: theme.primaryColor,
                          shape: shapeBorderRadius10,
                          child: CupertinoSearchTextField(
                            autofocus: textController.text.isEmpty,
                            placeholderStyle: theme.textTheme.subtitle2,
                            itemColor: theme.primaryColor,
                            borderRadius: borderRadius10,
                            backgroundColor: theme.backgroundColor,
                            controller: textController,
                            onSubmitted: (final value) {
                              context
                                  .read((todoSearchProvider).notifier)
                                  .setSearchText(value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: () => showSearchSettingsWidget(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: NotificationListener<UserScrollNotification>(
              onNotification: handelUserScrollNotification,
              child: Consumer(
                builder: (final context, final ref, final child) {
                  final providerState = ref.watch(todoSearchProvider);

                  return providerState.when(
                    emptyMessage: 'search'.tr(),
                    errorCall: () => ref.refresh(todoSearchProvider.notifier),
                    onData: (final data, final context) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              padding: paddingH20.copyWith(bottom: 90),
                              itemBuilder: (final context, final index) {
                                return TimelineTodoWidget(
                                  todo: data[index],
                                  provider: todoSearchProvider,
                                  showChecker: false,
                                );
                              },
                            ),
                          ),
                          ProviderScope(
                            overrides: [
                              _loadingPageWidgetScope.overrideWithValue(
                                providerState.isLoading,
                              ),
                            ],
                            child: const _LoadingPageWidget(),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  bool handelUserScrollNotification(final UserScrollNotification notification) {
    if (notification.metrics.pixels + 400 >=
        notification.metrics.maxScrollExtent)
      router.context.read(todoSearchProvider.notifier).getData();

    return true;
  }
}

class _LoadingPageWidget extends ConsumerWidget {
  const _LoadingPageWidget();

  @override
  Widget build(final context, final ref) {
    final isLoading = ref.watch(_loadingPageWidgetScope);

    return AnimatedPositioned(
      bottom: isLoading ? 50 : -10.0,
      left: 0,
      right: 0,
      child: AnimatedSwitcher(
        duration: kThemeChangeDuration,
        child: isLoading ? const CircularProgressIndicator() : const SizedBox(),
      ),
      duration: kThemeChangeDuration,
    );
  }
}

final _loadingPageWidgetScope = Provider.autoDispose<bool>((final ref) {
  throw UnimplementedError();
});
