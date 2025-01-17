import 'package:app/domain/actions/update_participant_alive_action.dart';
import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/_shared/hooks/use_periodic.dart';
import 'package:app/ui/_shared/widgets/participants_list.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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
    usePeriodic(10, UpdateParticipantAliveAction(roomId));

    return ProviderScope(
      overrides: [
        currentRoomIdProvider.overrideWith((_) => roomId),
      ],
      child: FScaffold(
        content: Stack(
          children: [
            Positioned(
              bottom: 16,
              right: 16,
              child: ParticipantsList(),
            ),
          ],
        ),
      ),
    );
  }
}
