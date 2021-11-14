//import essentials library
import 'dart:async';
import 'dart:developer';
import 'dart:io';

//import widget library
import 'package:camera/camera.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:score_scanner/debug.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:score_scanner/pages/csv/editablecsv.dart';


//import routes
import 'package:score_scanner/pages/filemanager/filemanager.dart';
import 'package:score_scanner/pages/camera/takepicture.dart';
import 'package:score_scanner/pages/settings.dart';

import 'modules/themechanger.dart';

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

  File tempfile = await fileManage.makeCSVasTemp("Untitled");

  runApp(MainApp(myFile: tempfile));
}

class MainApp extends StatelessWidget {
  late File myFile;
  MainApp({Key? key, required this.myFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeChanger(ThemeData.dark()),
        child: MainWidget(myFile: myFile,));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class MainWidget extends StatelessWidget {
  late File myFile;
  MainWidget({
    Key? key,
    required this.myFile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(builder: (context, themeChange, childe) {
      return MaterialApp(
          //Setting
          title: 'Score Scanner Mobile Application',
          theme: themeChange.getTheme(),
          //Routing
          initialRoute: '/cam',
          routes: {
            // '/': (BuildContext context) => new HomePage(),
            // '/2': (BuildContext context) => new SecondPage(),
            '/cam': (BuildContext context) => new TakePictureScreen(file: myFile, fileList: [],),
            '/file': (BuildContext context) => new fileManager(),
            '/settings': (BuildContext context) => new settingsPage(),
            '/debug': (BuildContext context) => new deBugScreen(),
          });
    });
  }
}