import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    super.key,
    this.imageUrl,
    this.imageProvider,
    this.child,
    this.radius = 25,
    this.backgroundColor,
  });

  final String? imageUrl;
  final ImageProvider? imageProvider;
  final Widget? child;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider = imageProvider;
    if (provider == null && imageUrl != null && imageUrl!.isNotEmpty) {
      provider = CachedNetworkImageProvider(imageUrl!);
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      backgroundImage: provider,
      child: provider == null ? child : null,
    );
  }
}
