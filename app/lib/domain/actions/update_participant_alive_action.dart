import 'dart:async';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/actions/action.dart';
import 'package:app/main.dart';

class UpdateParticipantAliveAction extends IAction<void> {
  const UpdateParticipantAliveAction(this.roomId);

  final String roomId;
  String get userId => inject<IPreferenceService>().getString(kUserGuid)!;

  @override
  FutureOr<void> execute() async {
    await RoomRepo.instance.updateParticipant(userId, roomId);
    await RoomRepo.instance.touchRoom(roomId);
  }
}
