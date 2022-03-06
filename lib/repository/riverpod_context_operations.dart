import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../root_app.dart';

extension RiverPodContext on BuildContext {
  T read<T>(final ProviderBase<T> provider) {
    return ProviderScope.containerOf(
      this,
      listen: false,
    ).read(provider);
  }

  State refresh<State>(final ProviderBase<State> provider) {
    return ProviderScope.containerOf(
      router.context,
      listen: false,
    ).refresh(provider);
  }
}
