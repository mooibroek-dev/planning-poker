import 'dart:async';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/actions/action.dart';
import 'package:app/domain/providers/room.provider.dart';
import 'package:app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DebugAction {
  addRandomParticipant,
  removeRandomParticipant,
}

class RunDebugAction extends RefAction<void> {
  const RunDebugAction(super.ref, this.action);

  final DebugAction action;

  IPreferenceService get prefs => inject();

  @override
  FutureOr<void> execute() async {
    final room = ref.read(roomProvider).asData?.value;
    if (room == null) return;

    switch (action) {
      case DebugAction.addRandomParticipant:
        await RoomRepo.instance.addRandomUser(room.id, room.participants.length);
        break;
      case DebugAction.removeRandomParticipant:
        final myParticipantKey = RoomRepo.instance.participantKeyForRoom(room.id);
        final otherParticipants = room.participants.where((p) => p.id != myParticipantKey).toList();

        if (otherParticipants.isEmpty) return;

        otherParticipants.shuffle();

        await RoomRepo.instance.removeRandomUser(otherParticipants.first.id);
        break;
    }
  }
}
