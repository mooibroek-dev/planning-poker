import 'package:app/domain/providers/room.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardSelection extends HookConsumerWidget {
  const CardSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(roomProvider.select((room) => room.value?.cards ?? []));

    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.center,
      runSpacing: -40,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: cards.map(Card.new).toList(),
    );
  }
}

class Card extends HookWidget {
  const Card(this.card, {super.key});

  final String card;

  @override
  Widget build(BuildContext context) {
    final isHovering = useState(false);
    return MouseRegion(
      onEnter: (_) => isHovering.value = true,
      onExit: (_) => isHovering.value = false,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, isHovering.value ? -20 : 0, 0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
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
        ),
      ),
    );
  }
}
