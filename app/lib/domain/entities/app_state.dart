import 'package:app/domain/entities/room.dart';

class AppState {
  AppState({
    required this.activeRoom,
  });

  final Room? activeRoom;
}
