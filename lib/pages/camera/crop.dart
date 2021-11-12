import 'dart:io';

import 'package:flutter/material.dart';

import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/modules/recognizer/brain.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:score_scanner/pages/camera/camera.dart';
import 'package:score_scanner/pages/camera/preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:score_scanner/modules/recognizer/brain.dart';

// A widget that displays the picture taken by the user.
class CropperScreen extends StatefulWidget {
  final File imageData;
  final File fileData;

  const CropperScreen({
    Key? key, 
    required this.imageData,
    required this.fileData
    })
      : super(key: key);
  @override
  _CropperScreenState createState() => _CropperScreenState();

}

class _CropperScreenState extends State<CropperScreen> {
  bool _isCrop = false;
  SharedPreferences? preferences;
  AppBrain brain = AppBrain();

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TakePictureScreen(file: widget.fileData)),
              );
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

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
     brain.loadModel();
  }

  Widget AIRecognition(File myFile) {
    return Column(
      children: [
        Image.file(myFile),
        FutureBuilder<List?>(
          future: brain.preProcessImage(myFile),
          builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Result: ${snapshot.data}'),
                )
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget ImageCropper() {
    if(_isCrop) {
      return
      FutureBuilder<File?>(
        future: ImageProcessor.cropImageDialog(widget.imageData.path),
        builder: (context, snapshot) {
          return snapshot.hasData 
          ? AIRecognition(snapshot.data!)
          : Center(child: CircularProgressIndicator());
        }
      );
    } else {
      return 
      FutureBuilder<File?>(
        future: ImageProcessor.cropSquare(widget.imageData.path, false),
        builder: (context, snapshot) {
          return snapshot.hasData 
          ? AIRecognition(snapshot.data!)
          : Center(child: CircularProgressIndicator());
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Recognition"),
        // leading: new IconButton(
        //   icon: new Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => TakePictureScreen(file: widget.fileData)),
        //     );
        //   },
        // ),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: WillPopScope(
        child: ImageCropper(),
      onWillPop: _onWillPop,
      )
    );
  }
}
