//import essentials library
import 'dart:async';
import 'dart:io';

//import widget library
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


//import routes
import 'package:score_scanner/debug/debug.dart';
import 'package:score_scanner/demo/ai/camerademo.dart';
import 'package:score_scanner/demo/homedemo.dart';
import 'package:score_scanner/demo/second.dart';
import 'package:score_scanner/demo/file.dart';
import 'package:score_scanner/pages/filemanager/filemanager.dart';
import 'package:score_scanner/pages/camera/camera.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  runApp(MaterialApp(
      //Setting
      title: 'Score Scanner Mobile Application',
      theme: ThemeData.dark(),
      //Routing
      initialRoute: '/cam',
      routes: {
        // '/': (BuildContext context) => new HomePage(),
        // '/2': (BuildContext context) => new SecondPage(),
        '/cam': (BuildContext context) => new TakePictureScreen(),
        '/file': (BuildContext context) => new fileManager(),
        '/debug': (BuildContext context) => new deBugScreen(),
      })
    );
}