import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:score_scanner/modules/drawer.dart';

import 'package:score_scanner/modules/recognizer/brain.dart';
import 'package:image/image.dart' as im;

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final XFile imageData;

  const DisplayPictureScreen({Key? key, required this.imageData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      drawer: PublicDrawer(),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imageData.path)),
    );
  }
}