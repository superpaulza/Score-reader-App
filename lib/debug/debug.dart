import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:score_scanner/demo/ai/camerademo.dart';
import 'package:score_scanner/demo/ai/filepicker.dart';
import 'package:score_scanner/demo/handwrite_ai/recognizer_screen.dart';

import 'package:score_scanner/modules/drawer.dart';

class deBugScreen extends StatefulWidget {
  final CameraDescription debugCamera;

  deBugScreen({Key? key, required this.debugCamera}) : super(key: key);

  @override
  _deBugScreenState createState() => _deBugScreenState();
}

class _deBugScreenState extends State<deBugScreen> {

  @override
  void initState() {
    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Developer Mode')),
      drawer: PublicDrawer(),
      body:
        Column(
        children: <Widget>[
          Center(
          child:
            ElevatedButton(
              onPressed: () {generateCSVFile();}, 
              child: Text(
                'Generate CSV', 
                style: TextStyle(fontSize: 22)
              ),
            )
          ),
          Center(
          child:
            ElevatedButton(
              onPressed: () {deletallCSVFile();}, 
              child: Text(
                'Delete all Files', 
                style: TextStyle(fontSize: 22)
              ),
            )
          ),
          Center(
          child:
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                    RecognizerScreen(),
                  ),
                );
              }, 
              child: Text(
                'Model Example', 
                style: TextStyle(fontSize: 22)
              ),
            )
          ),
          Center(
          child:
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                    filePickerScreen()
                  ),
                );
              }, 
              child: Text(
                'Test Model with image', 
                style: TextStyle(fontSize: 22)
              ),
            )
          ),
          Center(
          child:
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                    TakePictureScreenDebug(camera: widget.debugCamera)
                  ),
                );
              }, 
              child: Text(
                'Test Model with camera', 
                style: TextStyle(fontSize: 22)
              ),
            )
          ),
          Center(
          child:
            ElevatedButton(
              onPressed: () {log('eiei');}, 
              child: Text(
                'Log to console', 
                style: TextStyle(fontSize: 22)
              ),
            )
          ),
        ],
      )
    );
  }
}

  //Test Generate CSV Files
generateCSVFile() async {
  List<List<String>> data = [
    ['No', 'Score'],
    ['1','0'],
    ['2','20.99'],
    ['99','-9999']
  ];
  String csvData = ListToCsvConverter().convert(data);
  String directory = (await getApplicationSupportDirectory()).path;
  String filePath = '$directory/csv-${DateTime.now()}.csv';
  File file = File(filePath);
  await file.writeAsString(csvData);
  log("File created! locate in $directory/csv-${DateTime.now()}.csv");
}

deletallCSVFile() async {
  String directory = (await getApplicationSupportDirectory()).path;
  final targetFile = Directory(directory);
  try {
    if(targetFile.existsSync()) {
      targetFile.deleteSync(recursive: true);
    }
    } catch (e) {
      return 0;
    }
  log("File deleted!");
}