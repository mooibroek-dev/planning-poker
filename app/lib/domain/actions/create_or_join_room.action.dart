import 'dart:async';
import 'dart:math';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/actions/action.dart';
import 'package:app/domain/entities/room.dart';

class CreateOrJoinRoomAction extends RefAction<Room> {
  const CreateOrJoinRoomAction(super.ref, this.roomIdOrName);

  final String roomIdOrName;

  String get _randomString => Iterable.generate(15, (_) => String.fromCharCode(65 + Random().nextInt(26))).join();

  @override
  FutureOr<Room> execute() async {
    final isId = roomIdOrName.length == 15;
    final id = isId ? roomIdOrName : _randomString;

    final dbRoom = await RoomRepo.instance.createAndJoinRom(id, roomIdOrName);

    return Room.fromDbRoom(dbRoom);
  }
}
