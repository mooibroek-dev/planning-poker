import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/pages/room/widgets/room_card.dart';
import 'package:flutter/material.dart';
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
      children: cards.map(AnimatedRoomCard.new).toList(),
    );
  }
}
