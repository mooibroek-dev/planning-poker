// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DbRoom _$DbRoomFromJson(Map<String, dynamic> json) => DbRoom(
      json['id'] as String,
      json['owner_id'] as String,
      name: json['name'] as String?,
      participants: (json['participants'] as List<dynamic>?)
              ?.map(
                  (e) => DbRoomParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DbRoomToJson(DbRoom instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'participants': instance.participants,
    };

DbRoomParticipant _$DbRoomParticipantFromJson(Map<String, dynamic> json) =>
    DbRoomParticipant(
      json['guid'] as String,
      json['user_name'] as String,
    );

Map<String, dynamic> _$DbRoomParticipantToJson(DbRoomParticipant instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'user_name': instance.userName,
    };
