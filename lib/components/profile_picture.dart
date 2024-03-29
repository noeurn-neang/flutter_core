import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../configs/variables.dart';
import '../constants/dimens.dart';
import '../getx.dart';
import '../utils/image_utils.dart';
import 'buttons/icon_circle_button.dart';

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final String defaultImagePath;
  final double? size;

  final Function(XFile pickedFile) onImagePicked;

  final ImagePicker _picker = ImagePicker();

  ProfilePicture(
      {super.key,
      this.imageUrl,
      required this.defaultImagePath,
      required this.onImagePicked,
      this.size});

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
            maxHeight: Variables.maxUploadImageHeight);
        if (pickedFile != null) onImagePicked(pickedFile);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage = (imageUrl != null && imageUrl!.isNotEmpty
        ? NetworkImage(imageUrl!)
        : AssetImage(defaultImagePath)) as ImageProvider<Object>?;
    return Padding(
      padding: const EdgeInsets.all(Dimens.margin),
      child: Stack(
        alignment: const Alignment(1.5, 1.3),
        children: <Widget>[
          InkWell(
            onTap: imageUrl != null && imageUrl!.isNotEmpty
                ? () {
                    previewImage(context: Get.context!, imageUrl: imageUrl!);
                  }
                : null,
            child: CircleAvatar(
              backgroundImage: backgroundImage,
              radius: size ?? 50.0,
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
          )
        ],
      ),
    );
  }
}
