import 'dart:io';

import 'package:flutter/material.dart';

import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/modules/recognizer/brain.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A widget that displays the picture taken by the user.
class PreviewScreen extends StatefulWidget {
  final File imageData;
    final File fileData;

  const PreviewScreen({
    Key? key, 
    required this.imageData,
    required this.fileData
    })
      : super(key: key);
  @override
  _PreviewScreenState createState() => _PreviewScreenState();

}

class _PreviewScreenState extends State<PreviewScreen> {
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
      appBar: AppBar(title: const Text('Cropper')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[

        ],
      ),
    );
  }
}
