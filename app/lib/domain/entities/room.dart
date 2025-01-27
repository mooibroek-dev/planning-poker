import 'package:app/data/models/db_room.dart';
import 'package:app/data/repositories/room.repo.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum DeckType {
  standard,
  fibonacci,
  tshirt,
  custom;

  List<String> get _standardCards => ['0', '½', '1', '2', '3', '5', '8', '13', '20', '40', '100'];
  List<String> get _tshirtCards => ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  List<String> get _fibonacciCards => ['0', '1', '2', '3', '5', '8', '13', '21', '34'];

  List<String> get cards {
    switch (this) {
      case DeckType.standard:
        return _standardCards;
      case DeckType.fibonacci:
        return _fibonacciCards;
      case DeckType.tshirt:
        return _tshirtCards;
      case DeckType.custom:
        return [];
    }
  }
}

@immutable
class Room extends Equatable {
  final String id;
  final String name;
  final List<RoomParticipant> participants;
  final bool isNew;
  final bool canEdit;
  final List<String> cards;

  const Room({
    required this.id,
    required this.name,
    required this.participants,
    required this.isNew,
    required this.canEdit,
    this.cards = const [],
  });

  factory Room.fromDbRoom(DbRoom dbRoom) {
    final secondsOld = dbRoom.created?.difference(DateTime.now()).inSeconds;
    final myId = inject<IPreferenceService>().getString(kUserGuid)!;

    return Room(
      id: dbRoom.id,
      name: dbRoom.name ?? dbRoom.id,
      participants: dbRoom.participants?.map((e) => RoomParticipant.fromDbRoomParticipant(e, dbRoom.ownerId, dbRoom.id)).toList() ?? [],
      isNew: secondsOld != null && secondsOld.abs() < 1,
      canEdit: dbRoom.ownerId == myId,
      cards: dbRoom.cards,
    );
  }

  @override
  List<Object?> get props => [id, name, participants];

  bool get isReady => cards.isNotEmpty;

  List<RoomParticipant> participantsWithoutMe() => participants.where((e) => !e.isMe).toList();
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
