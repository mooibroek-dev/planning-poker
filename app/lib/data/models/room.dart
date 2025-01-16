// ignore_for_file: non_constant_identifier_names

import 'package:json/json.dart';
import 'package:pocketbase/pocketbase.dart';

@JsonCodable()
class Room {
  const Room(
    this.id,
    this.owner_id, [
    this.participants = const [],
    this.estimations = const [],
  ]);

  factory Room.fromRecord(RecordModel record) => Room.fromJson(record.toJson());

  final String id;
  final String owner_id;
  final List<RoomParticipant> participants;
  final List<EstimationRound> estimations;

  Room addUser(String userId, String userName) {
    final updatedParticipants = [
      ...participants,
      RoomParticipant(userId, userName),
    ];

    return Room(
      id,
      owner_id,
      updatedParticipants,
      estimations,
    );
  }
}

@JsonCodable()
class RoomParticipant {
  const RoomParticipant(this.guid, this.user_name);

  final String guid;
  final String user_name;
}

@JsonCodable()
class EstimationRound {
  final String guid;
  final String created_at;
  final List<Estimation> estimations;
}

@JsonCodable()
class Estimation {
  final String guid;
  final String userName;
  final int estimation;
}
