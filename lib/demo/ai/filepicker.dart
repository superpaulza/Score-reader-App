import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:score_scanner/demo/ai/aitest.dart';
import 'package:score_scanner/demo/ai/displaydemo.dart';
import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/modules/utility.dart';

class filePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test model with image'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Select files'),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg','png']);
            if (result == null) return;
            PlatformFile file = result.files.first;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreenDebug(
                  imageData: XFile(file.path as String)
                )
            ));
          },
        ),
      ),
      drawer: PublicDrawer(),
    );
  }
}