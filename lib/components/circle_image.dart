import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final Widget child;

  const CircleImage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(1), // Border radius
        child: SizedBox.fromSize(
          size: const Size.fromRadius(25),
          child: ClipOval(child: child),
        ),
      ),
    );
  }
}
