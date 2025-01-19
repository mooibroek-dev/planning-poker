import 'dart:async';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/actions/action.dart';
import 'package:app/domain/entities/room.dart';
import 'package:app/main.dart';

class UpdateRoomSettingsAction extends RefAction<void> {
  const UpdateRoomSettingsAction(super.ref, this.cards);

  final List<String> cards;

  @override
  FutureOr<void> execute() async {
    final room = appStateNotifier.value.activeRoom;
    if (room == null) return;

    final updatedRoom = await RoomRepo.instance.updateSettings(room.id, cards);
    appStateNotifier.value = appStateNotifier.value.copyWith(activeRoom: Room.fromDbRoom(updatedRoom));
  }
}
