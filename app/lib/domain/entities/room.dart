import 'package:app/data/models/db_room.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Room extends Equatable {
  final String id;
  final String name;
  final List<RoomParticipant> participants;

  const Room({
    required this.id,
    required this.name,
    required this.participants,
  });

  factory Room.fromDbRoom(DbRoom dbRoom) {
    return Room(
      id: dbRoom.id,
      name: dbRoom.name ?? dbRoom.id,
      participants: dbRoom.participants?.map(RoomParticipant.fromDbRoomParticipant).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [id, name, participants];
}

@immutable
class RoomParticipant extends Equatable {
  final String id;
  final String name;
  final DateTime? lastActive;

  const RoomParticipant({
    required this.id,
    required this.name,
    required this.lastActive,
  });

  factory RoomParticipant.fromDbRoomParticipant(DbRoomParticipant dbRoomParticipant) {
    return RoomParticipant(
      id: dbRoomParticipant.id,
      name: dbRoomParticipant.name,
      lastActive: dbRoomParticipant.updated,
    );
  }

  @override
  List<Object?> get props => [id, name, lastActive];
}
