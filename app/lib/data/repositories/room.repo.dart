import 'package:app/data/models/room.dart';
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

  Future<Room> createOrJoin(String id) async {
    var record = await _pbService.getOne(DbCollection.rooms, id);

    record ??= await _pbService.create(
      DbCollection.rooms,
      Room(id, userId).toJson(),
    );

    var room = Room.fromRecord(record);

    room = await addUserIfNotExists(room);

    return room;
  }

  Future<Room> addUserIfNotExists(Room room) async {
    // Already part of this room
    if (room.participants.any((element) => element.guid == userId)) {
      return room;
    }

    final updated = room.addUser(userId, userName);

    await _pbService.update(DbCollection.rooms, updated.id, updated.toJson());

    return updated;
  }
}
