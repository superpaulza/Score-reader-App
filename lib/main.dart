//import essentials library
import 'dart:async';
import 'dart:io';

//import widget library
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

//import routes
import 'package:score_scanner/pages/camera.dart';
import 'package:score_scanner/pages/home.dart';
import 'package:score_scanner/pages/second.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  
  runApp(MaterialApp(
      //Setting
      title: 'Score Scanner Mobile Application',
      theme: ThemeData.dark(),
      //Routing
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => new HomePage(),
        '/2': (BuildContext context) => new SecondPage(),
        '/cam': (BuildContext context) => new TakePictureScreen(camera: firstCamera),
      })
    );
}