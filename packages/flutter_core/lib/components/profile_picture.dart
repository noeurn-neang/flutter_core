import 'package:flutter/material.dart';
import 'package:flutter_core_common/flutter_core_common.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/image_utils.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({
    super.key,
    this.imageUrl,
    this.defaultImagePath,
    required this.onImagePicked,
    this.size,
  });

  final String? imageUrl;
  final String? defaultImagePath;
  final double? size;
  final void Function(XFile pickedFile) onImagePicked;
  final ImagePicker _picker = ImagePicker();

  Future<void> showPickImage(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (!context.mounted) return;
    try {
      final config = FlutterCoreConfig.current;
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: config.uploadImageQuality,
        maxWidth: config.maxUploadImageWidth,
        maxHeight: config.maxUploadImageHeight,
      );
      if (pickedFile != null) onImagePicked(pickedFile);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final radius = size ?? 50.0;
    return Padding(
      padding: const EdgeInsets.all(Dimens.margin),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          InkWell(
            onTap: imageUrl != null && imageUrl!.isNotEmpty
                ? () => previewImage(context: context, imageUrl: imageUrl!)
                : null,
            child: CircleImage(
              radius: radius,
              imageUrl: imageUrl,
              imageProvider: (imageUrl == null || imageUrl!.isEmpty) &&
                      defaultImagePath != null
                  ? AssetImage(defaultImagePath!)
                  : null,
            ),
          ),
          MenuAnchor(
            builder: (context, controller, child) {
              return CircleIconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.edit),
              );
            },
            menuChildren: [
              MenuItemButton(
                leadingIcon: const Icon(Icons.image),
                onPressed: () =>
                    showPickImage(ImageSource.gallery, context: context),
                child: Text('Gallery'.tr),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.camera),
                onPressed: () =>
                    showPickImage(ImageSource.camera, context: context),
                child: Text('Camera'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
