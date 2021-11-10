import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:score_scanner/demo/ai/aitest.dart';
import 'package:score_scanner/modules/drawer.dart';

import 'package:score_scanner/modules/recognizer/brain.dart';
import 'package:image/image.dart' as im;

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final File imageData;

  const DisplayPictureScreen({Key? key, required this.imageData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      drawer: PublicDrawer(),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        child: Stack(
          children: <Widget>[
            Image.file(
              File(imageData.path),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Align(
               alignment: Alignment.bottomCenter,
               child: 
                ElevatedButton(
                  child: const Text('Recognize this!'),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => aiTestScreen(
                          imageData: File(imageData.path)
                        )
                    ));
                    Navigator.pop(context);
                  },
                ),
            ),
          ]
        ),
      ),
    );
  }
}