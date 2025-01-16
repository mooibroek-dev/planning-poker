import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key, required this.roomId});

  final String roomId;

  static final route = GoRoute(
    path: '/room/:roomId',
    builder: (context, state) {
      final roomId = state.pathParameters['roomId']!;
      return RoomPage(roomId: roomId);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room: $roomId'),
      ),
      body: Center(
        child: Text('Welcome to room $roomId!'),
      ),
    );
  }
}
