import 'dart:async';

import 'package:app/core/logger.dart';
import 'package:app/data/models/db_room.dart';
import 'package:app/data/repositories/user.repo.dart';
import 'package:app/data/services/pocketbase.service.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/main.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uuid/uuid.dart';

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
    final room = await _getOrCreateRoom(id, name);
    return _joinRoom(room);
  }

  Future<DbRoom?> tryGetRoom(String id) async {
    final record = await _pbService.get(DbCollection.rooms, id, expand: expands);
    return record != null ? DbRoom.fromRecord(record) : null;
  }

  Future<DbRoom> _getOrCreateRoom(String id, [String? name]) async {
    var record = await _pbService.get(DbCollection.rooms, id, expand: expands);

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

  Future<DbRoom> addRandomUser(String roomId, int participantCount) async {
    await _pbService.create(DbCollection.participants, {
      'room': roomId,
      ...DbRoomParticipant('$roomId-${Uuid().v6()}', UserRepo.instance.randomName()).toJson(),
    });

    // Broadcast relation update to other clients
    unawaited(touchRoom(roomId));

    return _getOrCreateRoom(roomId);
  }

  Future<DbRoom> _joinRoom(DbRoom room) async {
    final participantKey = participantKeyForRoom(room.id);
    final inRoom = room.participants?.any((p) => p.id == participantKey) ?? false;

    if (inRoom) return room;

    await _pbService.create(DbCollection.participants, {
      'room': room.id,
      ...DbRoomParticipant(participantKey, userName).toJson(),
    });

    // Broadcast relation update to other clients
    unawaited(touchRoom(room.id));

    return _getOrCreateRoom(room.id);
  }

  Future<void> updateParticipant(String userId, String roomId) async {
    await _pbService.update(
      DbCollection.participants,
      participantKeyForRoom(roomId),
      {
        'updated': DateTime.now().toIso8601String(),
      },
    ).onError((error, stackTrace) {
      Log.w('RoomRepo.updateParticipant', error, stackTrace);
      return RecordModel();
    });
  }

  Stream<DbRoom> watchRoom(String id) {
    final controller = StreamController<DbRoom>();

    final listener = _pbService //
        .startWatch(DbCollection.rooms, id, expand: expands)
        .listen((record) => controller.add(DbRoom.fromRecord(record)));

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

  Future<void> removeRandomUser(String participantId) async {
    await _pbService.delete(DbCollection.participants, participantId);

    // Broadcast relation update to other clients
    unawaited(touchRoom(participantId.split('-').first));
  }
}
