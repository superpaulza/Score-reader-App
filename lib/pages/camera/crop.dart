import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/modules/recognizer/brain.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:score_scanner/pages/camera/display.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A widget that displays the picture taken by the user.
class CropperScreen extends StatefulWidget {
  final XFile imageData;

  const CropperScreen({Key? key, required this.imageData})
      : super(key: key);
  @override
  _CropperScreenState createState() => _CropperScreenState();

}

class _CropperScreenState extends State<CropperScreen> {
  bool _isCrop = false;
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _isCrop = (preferences!.getBool('isCrop') ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
     initializePreference().whenComplete(() {
       setState(() {});
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      drawer: PublicDrawer(),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: _isCrop
      ? FutureBuilder<File?>(
        future: ImageProcessor.cropImageDialog(widget.imageData.path),
        builder: (context, snapshot) {
          return snapshot.hasData 
          ? Image.file(snapshot.data!)
          : Center(child: CircularProgressIndicator());
        }
      )
      : FutureBuilder<File?>(
        future: ImageProcessor.cropSquare(widget.imageData.path, false),
        builder: (context, snapshot) {
          return snapshot.hasData 
          ? Image.file(snapshot.data!)
          : Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}
