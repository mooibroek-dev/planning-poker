import 'dart:async';

import 'package:app/data/models/db_room.dart';
import 'package:app/data/services/pocketbase.service.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/main.dart';

class RoomRepo {
  RoomRepo._();

  static RoomRepo get instance => RoomRepo._();

  IPocketBaseService get _pbService => inject();
  IPreferenceService get _prefs => inject();

  String get userId => _prefs.getString(kUserGuid)!;
  String get userName => _prefs.getString(kUsername)!;

  String get expands => 'participants_via_room';
  String participantKeyForRoom(String roomId) => '$roomId-$userId';

  Future<DbRoom> createAndJoinRom(String id, [String? name]) async {
    final room = await getOrCreateRoom(id, name);
    return joinRoom(room);
  }

  Future<DbRoom> getOrCreateRoom(String id, [String? name]) async {
    var record = await _pbService.getOne(DbCollection.rooms, id, expand: expands);

    record ??= await _pbService.create(
      DbCollection.rooms,
      DbRoom(
        id.toLowerCase(),
        userId,
        name: name,
      ).toJson(),
    );

    return DbRoom.fromRecord(record);
  }

  Future<DbRoom> joinRoom(DbRoom room) async {
    final participantKey = participantKeyForRoom(room.id);
    final inRoom = room.participants?.any((p) => p.id == participantKey) ?? false;

    if (inRoom) return room;

    await _pbService.create(DbCollection.participants, {
      'room': room.id,
      ...DbRoomParticipant(participantKey, userName).toJson(),
    });

    // Broadcast relation update to other clients
    unawaited(touchRoom(room.id));

    return getOrCreateRoom(room.id);
  }

  Future<void> updateParticipant(String userId, String roomId) async {
    await _pbService.update(
      DbCollection.participants,
      participantKeyForRoom(roomId),
      {
        'updated': DateTime.now().toIso8601String(),
      },
    );
  }

  Stream<DbRoom> watchRoom(String id) {
    final controller = StreamController<DbRoom>();

    final listener = _pbService.startWatch(DbCollection.rooms, id, expand: expands).listen((record) async {
      final room = DbRoom.fromRecord(record);
      controller.add(room);
    });

    controller.onCancel = () async {
      await stopWatchRoom(id);
      await listener.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  Future<void> stopWatchRoom(String id) async {
    await _pbService.stopWatch(DbCollection.rooms, id);
  }

  Future<void> touchRoom(String id) async {
    await _pbService.update(
      DbCollection.rooms,
      id,
      {
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }
}
