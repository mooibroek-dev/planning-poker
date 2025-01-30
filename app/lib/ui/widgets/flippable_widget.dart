import 'dart:math';

import 'package:flutter/material.dart';

class FlippableWidget extends StatelessWidget {
  const FlippableWidget({
    super.key,
    required this.front,
    required this.back,
    required this.showingFront,
  });

  final Widget front;
  final Widget back;
  final bool showingFront;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 800),
      transitionBuilder: (w, a) => __transitionBuilder(w, a, showingFront),
      layoutBuilder: (widget, list) => Stack(children: [widget, ...list].nonNulls.toList()),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
      child: showingFront ? Container(key: ValueKey(true), child: front) : Container(key: ValueKey(false), child: back),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation, bool isFront) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(isFront) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
