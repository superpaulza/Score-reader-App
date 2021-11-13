import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/modules/recognizer/brain.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:score_scanner/pages/camera/camera.dart';
import 'package:score_scanner/pages/camera/preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:score_scanner/modules/recognizer/brain.dart';

// A widget that displays the picture taken by the user.
class PreviewScreen extends StatefulWidget {
  final File imageData;
  final File fileData;
  final List<List<dynamic>> csvfileList;

  const PreviewScreen({
    Key? key, 
    required this.imageData,
    required this.fileData,
    required this.csvfileList
    })
      : super(key: key);
  @override
  _PreviewScreenState createState() => _PreviewScreenState();

}

class _PreviewScreenState extends State<PreviewScreen> {
  List aiReturn = [];
  String scoreData = "";
  String index = "";
  int lastedIndex = 0;
  
  TextEditingController _scoreController = TextEditingController();
  TextEditingController _indexController = TextEditingController();

  AppBrain brain = AppBrain();

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to discard this record'),
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
                MaterialPageRoute(builder: (context) => TakePictureScreen(file: widget.fileData, fileList: widget.csvfileList,)),
              );
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  void initState() {
    super.initState();
    brain.loadModel();
  }
  
   Future<void> _editRecordDialog(BuildContext context) async {
    _indexController.text = lastedIndex.toString();
    _scoreController.text = scoreData;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit record'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                onChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                controller: _indexController,
                decoration: InputDecoration(hintText: "Enter Student ID"),
                keyboardType: TextInputType.number,
                ),
                TextField(
                onChanged: (value) {
                  setState(() {
                    scoreData = value;
                  });
                },
                controller: _scoreController,
                decoration: InputDecoration(hintText: "Enter Score"),
                keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _indexController.clear();
                    _scoreController.clear();
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _indexController.clear();
                    _scoreController.clear();
                  });
                },
              ),

            ],
          );
        });
  }

  Widget resultsDisplay() {
    for (var i = 0; i < aiReturn.length; i++) {
      scoreData += aiReturn[i]["detectedClass"];
      lastedIndex = widget.csvfileList.length+1;
      index = lastedIndex.toString();
    }
    return Column(
      children: [
        Column(
          children: [
            Text(
            "Student ID",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 30
            ),
            ),
            Text(
            "$index",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold
            ),
            )
          ],
        ),
        Column(
          children: [
            Text(
            "Score",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 30
            ),
            ),
            Text(
            "$scoreData",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold
            ),
            )
          ],
        ),
        Padding(padding: EdgeInsets.all(10)),
        Align(
          alignment: Alignment.bottomCenter,
          child:  Row(
          children: [
          Expanded( 
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow.shade700),
              ),
              icon: Icon(Icons.edit),
              onPressed: () {
                _editRecordDialog(context);
              }, 
              label: Text(
                '\nEdit\n', 
                style: TextStyle(fontSize: 22)
              ),
            ),
          ),
          Expanded(
          child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {
                widget.csvfileList.add([index, scoreData]);
                fileManage.writeListDatatoFile(widget.csvfileList, widget.fileData.path);
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TakePictureScreen(
                    file: File(widget.fileData.path),
                    fileList: widget.csvfileList
                  )
                ));
              }, 
              label: Text(
                '\nAdd to List\n', 
                style: TextStyle(fontSize: 22)
              ),
            )
          )
          ],
        )
        )
      ],
    );
  }

  Widget AIRecognition(File myFile) {
    return Column(
      children: [
        FutureBuilder<List?>(
          future: brain.preProcessImage(myFile),
          builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
            List<Widget> children; 
            if (snapshot.hasData) {
              aiReturn = snapshot.data!;
              return resultsDisplay();
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
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  child: Image.file(widget.imageData),
                  width: 300,
                  height: 300,
                ),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            AIRecognition(widget.imageData),
          ],
        ),
      onWillPop: _onWillPop,
      )
    );
  }
}
