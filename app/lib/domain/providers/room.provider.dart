import 'dart:async';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/entities/room.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room.provider.g.dart';

@riverpod
String currentRoomId(Ref ref) => throw UnimplementedError(); // Override in widget tree with ProviderScope

@Riverpod(dependencies: [currentRoomId])
Stream<Room> room(Ref ref) {
  final id = ref.watch(currentRoomIdProvider);
  final controller = StreamController<Room>.broadcast();

  // Create or join the room
  RoomRepo.instance.createAndJoinRom(id).then((dbRoom) => controller.add(Room.fromDbRoom(dbRoom)));

  // Watch the room
  final listener = RoomRepo.instance //
      .watchRoom(id)
      .listen((dbRoom) => controller.add(Room.fromDbRoom(dbRoom)));

  ref.onDispose(() async {
    await listener.cancel();
    await controller.close();
  });

  return controller.stream;
}

@Riverpod(dependencies: [room])
List<RoomParticipant> participants(Ref ref) {
  final room = ref.watch(roomProvider);
  return room.value?.participants ?? [];
}
