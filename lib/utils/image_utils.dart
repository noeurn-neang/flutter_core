import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> convertXFileToBase64(XFile file) async {
  // Read the file as bytes
  List<int> fileBytes = await file.readAsBytes();

  // Convert bytes to base64 string
  String base64String = base64Encode(fileBytes);

  return base64String;
}

void previewImage({required BuildContext context, required String imageUrl}) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(color: Colors.black),
            width: double.infinity,
            child: Center(
              child: Image.network(
                imageUrl,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
