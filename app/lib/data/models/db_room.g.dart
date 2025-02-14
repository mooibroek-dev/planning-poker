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
      estimations: (json['estimations'] as List<dynamic>?)
              ?.map((e) => DbEstimation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cards:
          (json['cards'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$DbRoomToJson(DbRoom instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'created': instance.created?.toIso8601String(),
      'participants': instance.participants,
      'estimations': instance.estimations,
      'cards': instance.cards,
    };

DbRoomParticipant _$DbRoomParticipantFromJson(Map<String, dynamic> json) =>
    DbRoomParticipant(
      json['id'] as String,
      json['name'] as String,
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
      selectedCard: json['selected_card'] as String?,
    );

Map<String, dynamic> _$DbRoomParticipantToJson(DbRoomParticipant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'updated': instance.updated?.toIso8601String(),
      'selected_card': instance.selectedCard,
    };

DbEstimation _$DbEstimationFromJson(Map<String, dynamic> json) => DbEstimation(
      json['id'] as String,
      json['room_id'] as String,
      showingCards: json['showing_cards'] as bool?,
      breakdown: json['breakdown'] as Map<String, dynamic>?,
      estimatedValue: (json['estimated_value'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$DbEstimationToJson(DbEstimation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'showing_cards': instance.showingCards,
      'breakdown': instance.breakdown,
      'estimated_value': instance.estimatedValue,
      'is_active': instance.isActive,
    };
