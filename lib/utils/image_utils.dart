import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../getx.dart';
import 'message_utils.dart';

Future<String> convertXFileToBase64(XFile file) async {
  final fileBytes = await file.readAsBytes();
  return base64Encode(fileBytes);
}

Future<XFile> convertUint8ListToXFile(Uint8List uint8List) async {
  final appSupportDir = await getApplicationSupportDirectory();
  final fileName = path.basenameWithoutExtension(
    DateTime.now().toIso8601String(),
  );
  final filePath = path.join(appSupportDir.path, '$fileName.png');
  await File(filePath).writeAsBytes(uint8List);
  return XFile(filePath);
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
