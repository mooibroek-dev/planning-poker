import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ParticipantsList extends HookConsumerWidget {
  const ParticipantsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(participantsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: participants.map((participant) {
        return Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getLastActiveColor(participant.lastActive),
                ),
              ),
              Gap(6),
              Text(
                participant.name,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.end,
              ),
              if (participant.isMe) ...[
                Gap(4),
                Text(
                  '(You)',
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.end,
                ),
              ],
              if (participant.isOwner) ...[
                Gap(4),
                PPIcon(icon: FAssets.icons.crown, size: 10),
              ],
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

    if (difference.inSeconds < 10) {
      return Colors.green;
    } else if (difference.inSeconds < 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
