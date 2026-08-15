import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_common/flutter_core_common.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

Future<String> convertXFileToBase64(XFile file) async {
  final fileBytes = await file.readAsBytes();
  return base64Encode(fileBytes);
}

Future<XFile> convertUint8ListToXFile(Uint8List uint8List) async {
  return XFile.fromData(
    uint8List,
    mimeType: 'image/png',
    name: '${DateTime.now().millisecondsSinceEpoch}.png',
  );
}

Future<void> downloadImage(String imageUrl) async {
  if (kIsWeb) {
    showMessage('Saving to gallery is not available on web', isError: true);
    return;
  }
  showLoading();
  try {
    await Gal.putImage(imageUrl);
    hideLoading();
    showMessage('Image saved to gallery'.tr);
  } catch (_) {
    hideLoading();
    showMessage('Try again later.'.tr, isError: true);
  }
}

void previewImage({required BuildContext context, required String imageUrl}) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => downloadImage(imageUrl),
              icon: const Icon(Icons.download),
            ),
          ],
        ),
        body: PhotoView(imageProvider: NetworkImage(imageUrl)),
      ),
    ),
  );
}
