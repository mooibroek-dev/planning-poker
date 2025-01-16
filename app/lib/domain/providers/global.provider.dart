import 'dart:async';

import 'package:app/core/exceptions.dart';
import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/entities/room.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final globalLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final globalErrorProvider = StateProvider.autoDispose<DomainException?>((ref) => null);

final roomProvider = StreamProvider.family<Room, String>((ref, id) {
  final controller = StreamController<Room>.broadcast();

  // Create or join the room
  RoomRepo.instance.createOrJoin(id, null).then((dbRoom) => controller.add(Room.fromDbRoom(dbRoom)));

  // Watch the room
  RoomRepo.instance.watchRoom(id).then((stream) => stream.listen((dbRoom) => controller.add(Room.fromDbRoom(dbRoom))));

  ref.onDispose(() {
    RoomRepo.instance.stopWatchRoom(id);
    controller.close();
  });

  return controller.stream;
});
