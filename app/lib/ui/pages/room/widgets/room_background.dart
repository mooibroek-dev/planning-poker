import 'package:flutter/material.dart';

class RoomBackground extends StatelessWidget {
  const RoomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PokerTablePainter(),
      child: SizedBox.expand(),
    );
  }
}

class PokerTablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tablePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    // Draw the poker table background
    final tableRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
      Radius.circular((size.height - 20) / 2),
    );

    canvas.drawRRect(tableRect, tablePaint);
    canvas.drawRRect(tableRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
