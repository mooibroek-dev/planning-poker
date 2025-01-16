import 'package:app/domain/providers/global.provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoomPage extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(roomProvider(roomId));
    final room = data.asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(room?.name ?? 'Loading...'),
      ),
      body: Center(
        child: Text('Welcome to room $roomId!'),
      ),
    );
  }
}
