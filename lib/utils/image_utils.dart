import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import '../getx.dart';
import 'message_utils.dart';

Future<String> convertXFileToBase64(XFile file) async {
  // Read the file as bytes
  List<int> fileBytes = await file.readAsBytes();

  // Convert bytes to base64 string
  String base64String = base64Encode(fileBytes);

  return base64String;
}

Future<XFile> convertUint8ListToXFile(Uint8List uint8List) async {
  // Get the application support directory
  Directory appSupportDir = await getApplicationSupportDirectory();
  String appSupportPath = appSupportDir.path;

  // Generate a unique file name
  String fileName = path.basenameWithoutExtension(DateTime.now()
      .toIso8601String()); // Generate a unique file name using DateTime

  // Construct the file path
  String filePath = path.join(appSupportPath, '$fileName.png');

  // Write the Uint8List data to the file
  await File(filePath).writeAsBytes(uint8List);

  // Create an XFile object from the file path
  XFile xFile = XFile(filePath);

  return xFile;
}

void downloadImage(String imageUrl) async {
  showLoading();
  GallerySaver.saveImage(imageUrl).then((value) {
    hideLoading();
    if (value == true) {
      Get.snackbar(
        'Image Saved'.tr,
        'Image saved to gallery'.tr,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Something went wrong!'.tr,
        'Try again later.'.tr,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  });
}

void previewImage({required BuildContext context, required String imageUrl}) {
  var shadows = <Shadow>[const Shadow(color: Colors.black, blurRadius: 15.0)];
  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.black),
                width: double.infinity,
                child: Center(
                  child: PhotoView(
                    imageProvider: NetworkImage(
                      imageUrl,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        shadows: shadows,
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        downloadImage(imageUrl);
                      },
                      icon: Icon(
                        shadows: shadows,
                        Icons.download,
                        color: Colors.white,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
