import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
  });

  final Icon icon;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(const CircleBorder()),
        padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? scheme.surface,
        ),
        elevation: WidgetStateProperty.all(2),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return Theme.of(context).highlightColor;
          }
          return null;
        }),
      ),
      child: Icon(
        icon.icon,
        size: icon.size ?? 22,
        color: icon.color ?? scheme.primary,
      ),
    );
  }
}
