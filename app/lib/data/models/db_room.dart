import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'db_room.g.dart';

@JsonSerializable()
class DbRoom {
  const DbRoom(
    this.id,
    this.ownerId, {
    this.name,
    this.participants = const [],
  });

  final String id;
  final String ownerId;
  final String? name;
  final List<DbRoomParticipant>? participants;

  Map<String, dynamic> toJson() => _$DbRoomToJson(this);
  factory DbRoom.fromJson(Map<String, dynamic> json) => _$DbRoomFromJson(json);

  factory DbRoom.fromRecord(RecordModel record) {
    final room = DbRoom.fromJson(record.toJson());
    final participants = record //
        .get<List<RecordModel>>('expand.participants_via_room', [])
        .map(DbRoomParticipant.fromRecord)
        .toList();

    return DbRoom(
      room.id,
      room.ownerId,
      name: room.name,
      participants: participants,
    );
  }

  DbRoom addUser(String userId, String userName) {
    final updatedParticipants = [
      ...?participants,
      DbRoomParticipant(userId, userName),
    ];

    return DbRoom(
      id,
      ownerId,
      name: name,
      participants: updatedParticipants,
    );
  }
}

@JsonSerializable()
class DbRoomParticipant {
  const DbRoomParticipant(this.id, this.name, {this.updated});

  final String id;
  final String name;
  final DateTime? updated;

  Map<String, dynamic> toJson() => _$DbRoomParticipantToJson(this);
  factory DbRoomParticipant.fromJson(Map<String, dynamic> json) => _$DbRoomParticipantFromJson(json);
  factory DbRoomParticipant.fromRecord(RecordModel record) => _$DbRoomParticipantFromJson(record.toJson());
}
