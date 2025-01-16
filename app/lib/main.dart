import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/entities/app_state.dart';
import 'package:app/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final inject = GetIt.instance;

// Lives for the entire app lifecycle
late final ValueNotifier<AppState> appStateNotifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appStateNotifier = ValueNotifier(AppState(isLoggedIn: false));

  final prefs = LocalPrefsService();
  await prefs.preload();

  inject.registerSingleton<IPreferenceService>(prefs);

  runApp(ProviderScope(child: App()));
}
