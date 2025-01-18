// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DbRoom _$DbRoomFromJson(Map<String, dynamic> json) => DbRoom(
      json['id'] as String,
      json['owner_id'] as String,
      name: json['name'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
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
      'created': instance.created?.toIso8601String(),
      'participants': instance.participants,
    };

DbRoomParticipant _$DbRoomParticipantFromJson(Map<String, dynamic> json) =>
    DbRoomParticipant(
      json['id'] as String,
      json['name'] as String,
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$DbRoomParticipantToJson(DbRoomParticipant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'updated': instance.updated?.toIso8601String(),
    };
