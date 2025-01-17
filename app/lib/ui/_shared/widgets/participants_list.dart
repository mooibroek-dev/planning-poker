import 'package:app/domain/providers/room.provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ParticipantsList extends HookConsumerWidget {
  const ParticipantsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(participantsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: participants.map((participant) {
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
      }).toList(),
    );
  }

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
}
