import 'package:app/domain/actions/update_participant_alive_action.dart';
import 'package:app/domain/providers/global.provider.dart';
import 'package:app/ui/_shared/hooks/use_periodic.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
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

  Color _getLastActiveColor(DateTime? lastActive) {
    if (lastActive == null) {
      return Colors.red;
    }

    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) {
      return Colors.green;
    } else if (difference.inMinutes < 5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(roomProvider(roomId));
    final room = data.asData?.value;

    usePeriodic(10, UpdateParticipantAliveAction(roomId));

    return FScaffold(
      content: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: room?.participants.map((participant) {
                    return Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getLastActiveColor(participant.lastActive),
                            ),
                          ),
                          Gap(8),
                          Expanded(child: Text(participant.name, style: TextStyle(fontSize: 18))),
                        ],
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }
}
