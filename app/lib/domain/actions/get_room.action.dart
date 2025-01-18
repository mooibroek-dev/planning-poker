import 'dart:async';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/actions/action.dart';
import 'package:app/domain/entities/room.dart';

class GetRoomAction extends IAction<Room?> {
  const GetRoomAction(this.roomId);

  final String roomId;

  @override
  FutureOr<Room?> execute() async {
    final room = await RoomRepo.instance.tryGetRoom(roomId);
    if (room == null) return null;
    return Room.fromDbRoom(room);
  }
}
