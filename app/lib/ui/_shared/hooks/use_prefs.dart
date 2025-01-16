import 'dart:async';

import 'package:app/data/services/prefs.service.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<String?> usePrefs(String preferenceKey, {bool watchStream = false}) {
  final value = inject<IPreferenceService>().getString(preferenceKey);

  final notifier = useState(value);

  void listener() => inject<IPreferenceService>().set(preferenceKey, notifier.value);

  notifier.addListener(listener);

  useEffect(() {
    StreamSubscription<String?>? subscriber;
    if (watchStream) {
      subscriber = inject<IPreferenceService>().onPreferenceChanged(preferenceKey).listen((event) {
        notifier.value = event;
      });
    }

    return () {
      notifier.removeListener(listener);
      subscriber?.cancel();
    };
  });

  return notifier;
}
