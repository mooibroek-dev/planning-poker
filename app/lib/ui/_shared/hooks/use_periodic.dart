import 'dart:async';

import 'package:app/domain/actions/action.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void usePeriodic<T>(int seconds, IAction<T> action) {
  useEffect(
    () {
      // Also run the action immediately
      action();

      final timer = Timer.periodic(Duration(seconds: seconds), (_) => action());
      return timer.cancel;
    },
    [],
  );
}
