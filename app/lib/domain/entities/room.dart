import 'package:app/data/models/db_room.dart';
import 'package:app/data/repositories/room.repo.dart';
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
      participants: dbRoom.participants?.map((e) => RoomParticipant.fromDbRoomParticipant(e, dbRoom.ownerId, dbRoom.id)).toList() ?? [],
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
  final bool isMe;
  final bool isOwner;

  const RoomParticipant({
    required this.id,
    required this.name,
    required this.lastActive,
    required this.isMe,
    required this.isOwner,
  });

  factory RoomParticipant.fromDbRoomParticipant(DbRoomParticipant dbRoomParticipant, String ownerId, String roomId) {
    final myKey = RoomRepo.instance.participantKeyForRoom(roomId);
    final participantUserId = dbRoomParticipant.id.replaceAll('$roomId-', '');

    return RoomParticipant(
      id: dbRoomParticipant.id,
      name: dbRoomParticipant.name,
      lastActive: dbRoomParticipant.updated,
      isMe: dbRoomParticipant.id == myKey,
      isOwner: participantUserId == ownerId,
    );
  }

  @override
  List<Object?> get props => [id, name, lastActive, isMe];
}
