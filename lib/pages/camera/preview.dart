import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/modules/recognizer/brain.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:score_scanner/pages/camera/takepicture.dart';
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
  bool _isReturn = false;
  String fileName = "";
  late File newFile;

  TextEditingController _scoreController = TextEditingController();
  TextEditingController _renameController = TextEditingController();

  AppBrain brain = AppBrain();

  Future<void> _renameTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Save file as'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  fileName = value;
                });
              },
              controller: _renameController,
              decoration: InputDecoration(
                labelText: "File Name",
                hintText: "Enter filename"
                ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    fileName = "";
                    _renameController.clear();
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  newFile = await fileManage.makeCSV(fileName);
                  await fileManage.writeListDatatoFile(widget.csvfileList, newFile.path);
                  setState(() {
                    fileName = "";
                    _renameController.clear();
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                        file: newFile,
                        fileList: widget.csvfileList
                      ),
                    ),
                    (Route<dynamic> route) => false
                  );
                  });
                },
              ),

            ],
          );
        });
  }

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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                      file: File(widget.fileData.path),
                      fileList: widget.csvfileList
                    ),
                  ),
                  (route) => false
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    brain.loadModel();
    setState(() {
      newFile = widget.fileData;
    });
    if(!_isReturn) {
      AIRecognition();
    }
  }

  @override
  void dispose() {
    brain.close();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> AIRecognition() async {
    var recognition = await brain.NoAIBulletCurve(widget.imageData);
    setState(() {
      _isReturn = true;
      aiReturn = recognition!;
      for (var i = 0; i < aiReturn.length; i++) {
        scoreData += aiReturn[i]["detectedClass"];
      }
        lastedIndex = widget.csvfileList.length+1;
        index = lastedIndex.toString();
    });
    brain.close();
  }
  
  Future<void> _editRecordDialog(BuildContext context) async {
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
                controller: _scoreController,
                decoration: InputDecoration(
                    labelText: "Score",
                    hintText: "Enter score",
                ),
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
                    _scoreController.clear();
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    scoreData = _scoreController.text;
                    Navigator.pop(context);
                    _scoreController.clear();
                  });
                },
              ),

            ],
          );
        });
  }

  Widget resultsDisplay() {
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
            _isReturn
            ? Text(
            "$index",
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold
            ),
            )
            : CircularProgressIndicator()
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
            _isReturn 
            ? Text(
            scoreData == '' ? "Can\'t detected!" : "$scoreData",
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold
            ),
            )
            : CircularProgressIndicator()
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child:  Row(
          children: [
          Expanded( 
            child: 
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow.shade700),
              ),
              icon: Icon(Icons.edit),
              onPressed: () {
                _editRecordDialog(context);
              }, 
              label: Text(
                'Edit', 
                style: TextStyle(fontSize: 22)
              ),
            ),
          ),
          ),
          Expanded(
          child: Padding(
              padding: EdgeInsets.all(10),
              child:           
          ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () async {
                if(_isReturn) {
                  widget.csvfileList.add([index, scoreData]);
                if(widget.fileData.path.split('/').last == "Untitled.csv") {
                  await _renameTextInputDialog(context);
                } else {
                  await fileManage.writeListDatatoFile(widget.csvfileList, widget.fileData.path);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                      file: widget.fileData,
                      fileList: widget.csvfileList
                    ),
                  ),
                  (Route<dynamic> route) => false
                );
                }
                }
              }, 
              label: Text(
                'Add to List', 
                style: TextStyle(fontSize: 22)
              ),
            )
          )
          )
          ],
        )
        )
      ],
    );
  }

  // Widget AIRecognition(File myFile) {
  //   return Column(
  //     children: [
  //       FutureBuilder<List?>(
  //         future: brain.NoAIBulletCurve(myFile),
  //         builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
  //           List<Widget> children; 
  //           if (snapshot.hasData) {
  //             aiReturn = snapshot.data!;
  //             return resultsDisplay();
  //           } else if (snapshot.hasError) {
  //             children = <Widget>[
  //               const Icon(
  //                 Icons.error_outline,
  //                 color: Colors.red,
  //                 size: 60,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 16),
  //                 child: Text('Error: ${snapshot.error}'),
  //               )
  //             ];
  //           } else {
  //             children = const <Widget>[
  //               SizedBox(
  //                 child: CircularProgressIndicator(),
  //                 width: 60,
  //                 height: 60,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 16),
  //                 child: Text('Awaiting result...'),
  //               )
  //             ];
  //           }
  //           return Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: children,
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  //   List<Widget> renderBoxes(Size screen) {
  //   if (aiReturn == null) return [];
  //   if (Image.file(widget.imageData).width == null || Image.file(widget.imageData).height == null) return [];

  //   double factorX = screen.width;
  //   double factorY = _imageHeight / _imageHeight * screen.width;

  //   Color blue = Colors.blue;

  //   return _recognitions.map((re) {
  //     return Container(
  //       child: Positioned(
  //         left: re["rect"]["x"] * factorX,
  //         top: re["rect"]["y"] * factorY,
  //         width: re["rect"]["w"] * factorX,
  //         height: re["rect"]["h"] * factorY,
  //         child: ((re["confidenceInClass"] > 0.50))? Container(
  //             decoration: BoxDecoration(
  //               border: Border.all(
  //               color: blue,
  //               width: 3,
  //             )
  //           ),
  //           child: Text(
  //             "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
  //             style: TextStyle(
  //               background: Paint()..color = blue,
  //               color: Colors.white,
  //               fontSize: 15,
  //             ),
  //           ),
  //         ) : Container()
  //       ),
  //     );
  //   }).toList();
  // }

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
            resultsDisplay(),
          ],
        ),
      onWillPop: _onWillPop,
      )
    );
  }
}
