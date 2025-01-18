import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class PPIcon extends StatelessWidget {
  const PPIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.onTap,
  });

  final SvgAsset icon;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return FTappable.animated(
      onPress: onTap,
      child: Center(
        child: SizedBox.fromSize(
          size: Size.square(size),
          child: icon(
            colorFilter: ColorFilter.mode(
              brightness == Brightness.dark ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
