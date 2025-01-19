import 'dart:async';

import 'package:app/data/models/db_room.dart';
import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/entities/room.dart';
import 'package:app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room.provider.g.dart';

@riverpod
String currentRoomId(Ref ref) => throw UnimplementedError(); // Override in widget tree with ProviderScope

@Riverpod(dependencies: [currentRoomId])
Stream<Room> room(Ref ref) {
  final id = ref.watch(currentRoomIdProvider);
  final controller = StreamController<Room>.broadcast();

  void handleEvent(DbRoom dbRoom) {
    controller.add(Room.fromDbRoom(dbRoom));
    appStateNotifier.value = appStateNotifier.value.copyWith(activeRoom: Room.fromDbRoom(dbRoom));
  }

  // Create or join the room
  RoomRepo.instance.createAndJoinRom(id).then(handleEvent);

  // Watch the room
  final listener = RoomRepo.instance //
      .watchRoom(id)
      .listen(handleEvent);

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
