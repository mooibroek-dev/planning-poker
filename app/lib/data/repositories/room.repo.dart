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

  Future<DbRoom> createOrJoin(String id, String? name) async {
    var record = await _pbService.getOne(DbCollection.rooms, id);

    record ??= await _pbService.create(
      DbCollection.rooms,
      DbRoom(
        id.toLowerCase(),
        userId,
        name: name,
        participants: [
          DbRoomParticipant(userId, userName),
        ],
      ).toJson(),
    );

    var room = DbRoom.fromRecord(record);

    // When joining a room, make sure the user is part of it
    room = await _addUserIfNotExists(room);

    return room;
  }

  Future<Stream<DbRoom>> watchRoom(String id) async {
    return _pbService.startWatch(DbCollection.rooms, id).map(DbRoom.fromRecord);
  }

  Future<void> stopWatchRoom(String id) async {
    await _pbService.stopWatch(DbCollection.rooms, id);
  }

  Future<DbRoom> _addUserIfNotExists(DbRoom room) async {
    // Already part of this room
    if (room.participants?.any((element) => element.guid == userId) ?? true) {
      return room;
    }

    final updated = room.addUser(userId, userName);

    await _pbService.update(DbCollection.rooms, updated.id, updated.toJson());

    return updated;
  }
}
