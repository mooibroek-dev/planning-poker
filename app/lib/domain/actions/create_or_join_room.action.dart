import 'dart:async';
import 'dart:math';

import 'package:app/data/repositories/room.repo.dart';
import 'package:app/domain/actions/action.dart';

class CreateOrJoinRoomAction extends RefAction<String> {
  const CreateOrJoinRoomAction(super.ref, this.roomId);

  final String roomId;

  String get _randomString => Iterable.generate(15, (_) => String.fromCharCode(65 + Random().nextInt(26))).join();

  @override
  FutureOr<String> execute() async {
    final id = (roomId.isEmpty ? _randomString : roomId).toLowerCase();

    final record = await RoomRepo.instance.createOrJoin(id);

    return id;
  }
}
