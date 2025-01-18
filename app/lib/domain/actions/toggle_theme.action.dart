import 'dart:async';

import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/actions/action.dart';
import 'package:app/main.dart';

class ToggleThemeAction extends RefAction<void> {
  const ToggleThemeAction(super.ref);

  IPreferenceService get prefs => inject();

  @override
  FutureOr<void> execute() {
    final isDark = prefs.getBoolean(kDarkmodeEnabled);
    prefs.set(kDarkmodeEnabled, !isDark);
  }
}
