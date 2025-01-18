import 'package:app/domain/actions/run_debug.action.dart';
import 'package:app/domain/actions/toggle_theme.action.dart';
import 'package:app/domain/actions/update_participant_alive_action.dart';
import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/_shared/hooks/use_periodic.dart';
import 'package:app/ui/_shared/routing/router.dart';
import 'package:app/ui/pages/room/widgets/participants_list.dart';
import 'package:app/ui/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FAccordion(
            items: [
              FAccordionItem(
                title: Text('Debug actions', style: TextStyle(fontSize: 14)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PPIconButton(
                        onTap: RunDebugAction(ref, DebugAction.addRandomParticipant).call,
                        icon: FAssets.icons.userPlus,
                      ),
                      PPIconButton(
                        onTap: RunDebugAction(ref, DebugAction.removeRandomParticipant).call,
                        icon: FAssets.icons.userMinus,
                      ),
                    ],
                  ),
                ),
              ),
              FAccordionItem(
                title: Text('Information', style: TextStyle(fontSize: 14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      label: 'Room ID:',
                      value: room?.id ?? 'Loading...',
                      isCopyable: true,
                    ),
                    _InfoRow(
                      label: 'Participants:',
                      value: room?.participants.length.toString() ?? 'Loading...',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isCopyable = false,
  });

  final String label;
  final String value;
  final bool isCopyable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Gap(4),
          Text(value, style: TextStyle(fontSize: 12)),
          if (isCopyable) ...[
            Gap(4),
            PPIcon(
              onTap: () => Clipboard.setData(ClipboardData(text: value)),
              icon: FAssets.icons.copy,
              size: 12,
            ),
          ],
        ],
      ),
    );
  }
}
