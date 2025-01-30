import 'package:app/core/extensions.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/actions/run_debug.action.dart';
import 'package:app/domain/actions/toggle_theme.action.dart';
import 'package:app/domain/entities/app_state.dart';
import 'package:app/domain/providers/room.provider.dart';
import 'package:app/main.dart';
import 'package:app/ui/_shared/hooks/use_prefs.dart';
import 'package:app/ui/_shared/routing/router.dart';
import 'package:app/ui/pages/room/room_base.page.dart';
import 'package:app/ui/pages/room/widgets/card_selection.dart';
import 'package:app/ui/pages/room/widgets/other_users.dart';
import 'package:app/ui/pages/room/widgets/participants_list.dart';
import 'package:app/ui/pages/room/widgets/room_background.dart';
import 'package:app/ui/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoomPage extends HookConsumerWidget {
  const RoomPage({super.key, required this.roomId});

  final String roomId;

  static String path(String roomId) => '/room/$roomId';

  static final route = CrossFadeRoute(
    path: '/room/:roomId',
    builder: (context, state) {
      final roomId = state.pathParameters['roomId']!;
      return RoomPage(roomId: roomId);
    },
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRoomPage(
      roomId: roomId,
      child: FScaffold(
        content: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: _HeaderTitle(),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1000),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: RoomBackground(),
                      ),
                      _OtherUsers(),
                      _CardSelection(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _Actions(),
            ),
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

class _Actions extends HookConsumerWidget {
  const _Actions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkEnabled = usePrefs(kDarkmodeEnabled, watchStream: true).value.isTrue;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PPIcon(
          onTap: ToggleThemeAction(ref).call,
          icon: isDarkEnabled ? FAssets.icons.sun : FAssets.icons.moon,
          size: 30,
        ),
        Gap(24),
        PPIcon(
          onTap: () => appStateNotifier.value = AppState(activeRoom: null),
          icon: FAssets.icons.logOut,
          size: 30,
        ),
      ],
    );
  }
}

class _OtherUsers extends HookConsumerWidget {
  const _OtherUsers();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      left: 40,
      right: 40,
      bottom: 40,
      top: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: .7,
          child: OtherUsers(),
        ),
      ),
    );
  }
}

class _CardSelection extends HookConsumerWidget {
  const _CardSelection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      left: 40,
      right: 40,
      bottom: -40,
      top: 60,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: .6,
          heightFactor: .3,
          child: CardSelection(),
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

    return Align(
      alignment: Alignment.topLeft,
      child: room.when(
        data: (room) => Text('Room: ${room.name}', style: TextStyle(fontSize: 24)),
        loading: () => Text('Loading...'),
        error: (error, _) => Text('Error while fetching, try again¬'),
      ),
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
