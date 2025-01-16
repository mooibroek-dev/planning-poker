import 'package:app/core/extensions.dart';
import 'package:app/data/services/pocketbase.service.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/entities/app_state.dart';
import 'package:app/env.dart';
import 'package:app/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

final inject = GetIt.instance;

// Lives for the entire app lifecycle
late final ValueNotifier<AppState> appStateNotifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = LocalPrefsService();
  await prefs.preload();

  String? userGuid = prefs.getString(kUserGuid);
  if (userGuid == null) {
    userGuid = Uuid().v6();
    await prefs.set(kUserGuid, userGuid);
  }

  final userName = prefs.getString(kUsername);
  if (userName == null) {
    await prefs.set(kUsername, _randomName());
  }

  appStateNotifier = ValueNotifier(AppState(userGuid: userGuid));

  inject.registerSingleton<Env>(Env.fromEnvironment());
  inject.registerSingleton<IPreferenceService>(prefs);
  inject.registerSingleton<IPocketBaseService>(PocketBaseService());

  runApp(ProviderScope(child: App()));
}

String _randomName() {
  final funnyFirstNames = ['Funny', 'Crazy', 'Silly', 'Goofy', 'Wacky', 'Zany', 'Loony', 'Nutty', 'Kooky', 'Batty'];
  final funnyLastNames = ['Banana', 'Pickle', 'Peanut', 'Pumpkin', 'Apple', 'Peach', 'Pineapple', 'Strawberry', 'Blueberry', 'Grape'];

  return '${funnyFirstNames.random()} ${funnyLastNames.random()}';
}
