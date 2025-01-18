import 'package:app/data/repositories/user.repo.dart';
import 'package:app/data/services/event_source.service.dart';
import 'package:app/data/services/pocketbase.service.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/actions/get_room.action.dart';
import 'package:app/domain/entities/app_state.dart';
import 'package:app/domain/entities/room.dart';
import 'package:app/env.dart';
import 'package:app/ui/app.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
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
    await prefs.set(kUsername, UserRepo.instance.randomName());
  }

  if (kIsWeb) {
    inject.registerSingleton<IEventSourceService>(EventSourceService());
  }

  inject.registerSingleton<Env>(Env.fromEnvironment());
  inject.registerSingleton<IPreferenceService>(prefs);
  inject.registerSingleton<IPocketBaseService>(PocketBaseService());

  Room? activeRoom;
  if (kIsWeb) {
    // Pattern to check URL and extract room ID
    final hash = Uri.base.fragment;
    final matcher = RegExp(r'^/room/(\w+)(?:/|$)', caseSensitive: false).firstMatch(hash);
    if (matcher != null) {
      final roomId = matcher.group(1)!;
      activeRoom = await GetRoomAction(roomId).call();
    }
  }

  appStateNotifier = ValueNotifier(AppState(activeRoom: activeRoom));

  runApp(ProviderScope(child: App()));

  if (!kIsWeb) {
    doWhenWindowReady(() {
      const initialSize = Size(800, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}
