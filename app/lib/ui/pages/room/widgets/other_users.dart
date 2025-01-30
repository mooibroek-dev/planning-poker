import 'dart:math';

import 'package:app/domain/actions/select_card.action.dart';
import 'package:app/domain/entities/room.dart';
import 'package:app/domain/providers/room.provider.dart';
import 'package:app/ui/pages/room/widgets/room_card.dart';
import 'package:app/ui/widgets/flippable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtherUsers extends HookConsumerWidget {
  const OtherUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(roomProvider.select((room) => room.value?.participantsWithoutMe() ?? []));

    return Center(
      child: Wrap(
        spacing: 30,
        runSpacing: 20,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: participants.map(UserCard.new).toList(),
      ),
    );
  }
}

class UserCard extends HookConsumerWidget {
  const UserCard(this.participant, {super.key});

  final RoomParticipant participant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFlipped = useState(true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FTappable(
          onLongPress: SelectCardAction(ref, 'S', participantId: participant.id).call,
          onPress: () => isFlipped.value = !isFlipped.value,
          child: FlippableWidget(
            front: RoomCard(participant.selectedCard ?? ' '),
            back: BaseCard(child: participant.selectedCard?.isEmpty == true ? PlaceholderCard() : CardBack()),
            showingFront: !isFlipped.value,
          ),
        ),
        Gap(4),
        Text(participant.name, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  const PlaceholderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Container(
        width: 60,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.green,
        ),
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CardBackPainter(),
      child: SizedBox(width: 60, height: 80),
    );
  }
}

class CardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    // Draw the background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw some custom design
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;

    canvas.drawRRect(RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(8)), paint);

    // Add checkered pattern
    canvas.rotate(pi / 4);
    canvas.translate(-size.width / 2, -size.height / 2);

    final path = Path();
    const double squareSize = 11.0;

    for (double y = 0; y < size.height * 3; y += squareSize) {
      for (double x = 0; x < size.width * 3; x += squareSize) {
        if ((x / squareSize).floor() % 2 == (y / squareSize).floor() % 2) {
          path.addRect(Rect.fromLTWH(x, y, squareSize, squareSize));
        }
      }
    }

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
