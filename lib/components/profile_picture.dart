import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../cached_network_imagex.dart';
import '../configs/variables.dart';
import '../constants/dimens.dart';
import '../getx.dart';
import '../utils/image_utils.dart';

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final String defaultImagePath;
  final double? size;

  final Function(XFile pickedFile) onImagePicked;

  final ImagePicker _picker = ImagePicker();

  ProfilePicture({
    super.key,
    this.imageUrl,
    required this.defaultImagePath,
    required this.onImagePicked,
    this.size,
  });

  Future<void> showPickImage(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: Variables.uploadImageQuaility,
          maxWidth: Variables.maxUploadImageWidth,
          maxHeight: Variables.maxUploadImageHeight,
        );
        if (pickedFile != null) onImagePicked(pickedFile);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final diameter = (size ?? 50.0) * 2;

    Widget avatar;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = ClipOval(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            memCacheWidth: (diameter * 2).round().clamp(1, 4096),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => Image.asset(
              defaultImagePath,
              width: diameter,
              height: diameter,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      avatar = ClipOval(
        child: Image.asset(
          defaultImagePath,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Dimens.margin),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: imageUrl != null && imageUrl!.isNotEmpty
                ? () {
                    previewImage(context: Get.context!, imageUrl: imageUrl!);
                  }
                : null,
            customBorder: const CircleBorder(),
            child: avatar,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: MenuAnchor(
              builder: (context, controller, child) {
                final scheme = Theme.of(context).colorScheme;
                return Material(
                  elevation: 2,
                  shadowColor: Colors.black26,
                  color: scheme.surface,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.edit_rounded,
                        color: scheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                );
              },
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(Icons.image),
                  child: Text('Gallery'.tr),
                  onPressed: () {
                    showPickImage(ImageSource.gallery, context: context);
                  },
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.camera),
                  child: Text('Camera'.tr),
                  onPressed: () {
                    showPickImage(ImageSource.camera, context: context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
