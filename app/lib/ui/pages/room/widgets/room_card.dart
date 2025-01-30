import 'package:app/domain/providers/room.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnimatedRoomCard extends HookConsumerWidget {
  const AnimatedRoomCard(
    this.card, {
    super.key,
  });

  final String card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovering = useState(false);
    final selectedCard = ref.watch(myParticipantProvider.select((p) => p))?.selectedCard;
    final isSelected = card == selectedCard;

    return MouseRegion(
      onEnter: (_) => isHovering.value = true,
      onExit: (_) => isHovering.value = false,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          0,
          isSelected
              ? -40
              : isHovering.value
                  ? -20
                  : 0,
          0,
        ),
        child: RoomCard(card),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard(this.card, {super.key});

  final String card;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(card),
        ),
      ),
    );
  }
}

class BaseCard extends StatelessWidget {
  const BaseCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadii = BorderRadius.circular(8);
    return SizedBox(
      width: 60,
      height: 80,
      child: FCard(
        style: context.theme.cardStyle.copyWith(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.secondary,
            borderRadius: borderRadii,
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.secondaryForeground.withValues(alpha: .1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          contentStyle: context.theme.cardStyle.contentStyle.copyWith(
            padding: EdgeInsets.zero,
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadii,
          child: child,
        ),
      ),
    );
  }
}
