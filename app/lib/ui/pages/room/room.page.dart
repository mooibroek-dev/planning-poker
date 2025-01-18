import 'package:app/domain/actions/run_debug.action.dart';
import 'package:app/domain/actions/toggle_theme.action.dart';
import 'package:app/domain/actions/update_participant_alive_action.dart';
import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/_shared/hooks/use_periodic.dart';
import 'package:app/ui/_shared/routing/router.dart';
import 'package:app/ui/pages/room/widgets/participants_list.dart';
import 'package:app/ui/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoomPage extends HookConsumerWidget {
  const RoomPage({super.key, required this.roomId});

  final String roomId;

  static final route = CrossFadeRoute(
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
        header: AppBar(
          title: _HeaderTitle(),
          actions: [
            PPIcon(
              onTap: ToggleThemeAction(ref).call,
              icon: FAssets.icons.lightbulb,
            ),
            Gap(8),
            PPIcon(
              onTap: () => context.go('/'),
              icon: FAssets.icons.logOut,
            ),
            Gap(8),
          ],
        ),
        content: Stack(
          children: [
            Positioned(
              bottom: 16,
              right: 16,
              child: ParticipantsList(),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: _DebugBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderTitle extends HookConsumerWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomProvider);

    return room.when(
      data: (room) => Text(room.name),
      loading: () => Text('Loading...'),
      error: (error, _) => Text('Error while fetching, try again¬'),
    );
  }
}

class _DebugBar extends HookConsumerWidget {
  const _DebugBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomProvider.select((room) => room.asData?.value));

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
      child: FAccordion(
        items: [
          FAccordionItem(
            title: Text('Debug panel'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FButton.icon(
                      onPress: RunDebugAction(ref, DebugAction.addRandomParticipant).call,
                      child: FAssets.icons.userPlus(),
                    ),
                    FButton.icon(
                      onPress: RunDebugAction(ref, DebugAction.removeRandomParticipant).call,
                      child: FAssets.icons.userMinus(),
                    ),
                  ],
                ),
                Gap(8),
                Text('Room id: ${room?.id}', style: TextStyle(fontSize: 12)),
                Text('Participants: ${room?.participants.length}', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
