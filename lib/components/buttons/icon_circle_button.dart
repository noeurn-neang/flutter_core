import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton(
      {super.key, required this.icon, this.onPressed, this.backgroundColor});

  final Icon icon;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const CircleBorder()),
        padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
        backgroundColor: MaterialStateProperty.all(
            backgroundColor ?? Colors.white), // <-- Button color
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).highlightColor; // <-- Splash color
          }
          return null;
        }),
      ),
      child: icon,
    );
  }
}
