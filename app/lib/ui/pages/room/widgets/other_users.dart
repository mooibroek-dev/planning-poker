import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/pages/room/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtherUsers extends HookConsumerWidget {
  const OtherUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(roomProvider.select((room) => room.value?.participantsWithoutMe ?? []));

    return Center(child: FlippableCard());
  }
}

class FlippableCard extends HookConsumerWidget {
  const FlippableCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoomCard(' ');
  }
}
