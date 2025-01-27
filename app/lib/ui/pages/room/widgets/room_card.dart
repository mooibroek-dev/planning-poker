import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';

class AnimatedRoomCard extends HookWidget {
  const AnimatedRoomCard(
    this.card, {
    super.key,
    this.offsetWhenSelected,
  });

  final String card;
  final Offset? offsetWhenSelected;

  @override
  Widget build(BuildContext context) {
    final isHovering = useState(false);
    final isSelected = useState(true);

    final double hoveringY = (isHovering.value ? 20 : 0);

    return MouseRegion(
      onEnter: (_) => isHovering.value = true,
      onExit: (_) => isHovering.value = false,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          isSelected.value ? -(offsetWhenSelected?.dx ?? 0) : 0,
          isSelected.value ? -((offsetWhenSelected?.dy ?? 0) + hoveringY) : -hoveringY,
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
    return SizedBox(
      width: 60,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: FCard(
          style: context.theme.cardStyle.copyWith(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: context.theme.colorScheme.secondaryForeground.withValues(alpha: .1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            contentStyle: context.theme.cardStyle.contentStyle.copyWith(
              padding: EdgeInsets.all(8),
            ),
          ),
          child: Center(
            child: Text(card),
          ),
        ),
      ),
    );
  }
}
