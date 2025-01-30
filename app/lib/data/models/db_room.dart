import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'db_room.g.dart';

@JsonSerializable()
class DbRoom {
  const DbRoom(
    this.id,
    this.ownerId, {
    this.name,
    this.created,
    this.participants = const [],
    this.estimations = const [],
    this.cards = const [],
  });

  final String id;
  final String ownerId;
  final String? name;
  final DateTime? created;
  final List<DbRoomParticipant>? participants;
  final List<DbEstimation>? estimations;
  final List<String> cards;

  Map<String, dynamic> toJson() => _$DbRoomToJson(this);
  factory DbRoom.fromJson(Map<String, dynamic> json) => _$DbRoomFromJson(json);

  factory DbRoom.fromRecord(RecordModel record) {
    final room = DbRoom.fromJson(record.toJson());

    final participants = record //
        .get<List<RecordModel>>('expand.participants_via_room', [])
        .map(DbRoomParticipant.fromRecord)
        .toList();

    final estimations = record //
        .get<List<RecordModel>>('expand.estimations_via_room', [])
        .map(DbEstimation.fromRecord)
        .toList();

    return room.copyWith(
      participants: participants,
      estimations: estimations,
    );
  }

  DbRoom addUser(String userId, String userName) {
    final updatedParticipants = [
      ...?participants,
      DbRoomParticipant(userId, userName),
    ];

    return copyWith(
      participants: updatedParticipants,
    );
  }

  DbRoom copyWith({
    String? name,
    DateTime? created,
    List<DbRoomParticipant>? participants,
    List<DbEstimation>? estimations,
    List<String>? cards,
  }) {
    return DbRoom(
      id,
      ownerId,
      name: name ?? this.name,
      created: created ?? this.created,
      participants: participants ?? this.participants,
      estimations: estimations ?? this.estimations,
      cards: cards ?? this.cards,
    );
  }
}

@JsonSerializable()
class DbRoomParticipant {
  const DbRoomParticipant(
    this.id,
    this.name, {
    this.updated,
    this.selectedCard,
  });

  final String id;
  final String name;
  final DateTime? updated;
  final String? selectedCard;

  Map<String, dynamic> toJson() => _$DbRoomParticipantToJson(this);
  factory DbRoomParticipant.fromJson(Map<String, dynamic> json) => _$DbRoomParticipantFromJson(json);
  factory DbRoomParticipant.fromRecord(RecordModel record) => _$DbRoomParticipantFromJson(record.toJson());
}

@JsonSerializable()
class DbEstimation {
  const DbEstimation(
    this.id,
    this.roomId, {
    this.showingCards,
    this.breakdown,
    this.estimatedValue,
    this.isActive,
  });

  final String id;
  final String roomId;
  final bool? showingCards;
  final Map<String, dynamic>? breakdown;
  final int? estimatedValue;
  final bool? isActive;

  Map<String, dynamic> toJson() => _$DbEstimationToJson(this);
  factory DbEstimation.fromJson(Map<String, dynamic> json) => _$DbEstimationFromJson(json);
  factory DbEstimation.fromRecord(RecordModel record) => _$DbEstimationFromJson(record.toJson());
}
