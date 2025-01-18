import 'package:app/domain/actions/update_participant_alive_action.dart';
import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/_shared/hooks/use_periodic.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BaseRoomPage extends HookConsumerWidget {
  const BaseRoomPage({
    super.key,
    required this.roomId,
    required this.child,
  });

  final String roomId;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    usePeriodic(10, UpdateParticipantAliveAction(roomId));

    return ProviderScope(
      overrides: [
        currentRoomIdProvider.overrideWith((_) => roomId),
      ],
      child: child,
    );
  }
}
