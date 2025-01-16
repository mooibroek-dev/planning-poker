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
  factory DbRoom.fromRecord(RecordModel record) => _$DbRoomFromJson(record.toJson());
  factory DbRoom.fromJson(Map<String, dynamic> json) => _$DbRoomFromJson(json);

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
  const DbRoomParticipant(this.guid, this.userName);

  final String guid;
  final String userName;

  Map<String, dynamic> toJson() => _$DbRoomParticipantToJson(this);
  factory DbRoomParticipant.fromJson(Map<String, dynamic> json) => _$DbRoomParticipantFromJson(json);
}
