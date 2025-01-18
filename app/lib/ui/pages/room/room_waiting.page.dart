import 'package:app/ui/_shared/routing/router.dart';
import 'package:app/ui/pages/room/room_base.page.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoomWaitingPage extends HookConsumerWidget {
  const RoomWaitingPage({super.key, required this.roomId});

  final String roomId;

  static String path(String roomId) => '/room/$roomId/waiting';

  static final route = CrossFadeRoute(
    path: '/room/:roomId/waiting',
    builder: (_, state) {
      final roomId = state.pathParameters['roomId']!;
      return RoomWaitingPage(roomId: roomId);
    },
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRoomPage(
      roomId: roomId,
      child: FScaffold(
        content: Center(
          child: Text('Waiting for host to finish setting up the room...'),
        ),
      ),
    );
  }
}
