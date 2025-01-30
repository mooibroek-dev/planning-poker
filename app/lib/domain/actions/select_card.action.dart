import 'dart:async';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/actions/action.dart';
import 'package:app/domain/providers/room.provider.dart';

class SelectCardAction extends RefAction<void> {
  const SelectCardAction(super.ref, this.card, {this.participantId});

  final String card;
  final String? participantId;

  @override
  FutureOr<void> execute() async {
    if (participantId != null) {
      await RoomRepo.instance.selectCard(participantId!, card);
    } else {
      final myParticipant = ref.read(myParticipantProvider.select((p) => p));

      if (myParticipant == null) {
        return;
      }

      final isSelected = card == myParticipant.selectedCard;

      await RoomRepo.instance.selectCard(myParticipant.id, isSelected ? null : card);
    }

    final roomId = ref.read(currentRoomIdProvider);
    await RoomRepo.instance.touchRoom(roomId);
  }
}
