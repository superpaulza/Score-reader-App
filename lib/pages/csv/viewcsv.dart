import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:score_scanner/pages/camera/takepicture.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:share/share.dart';

class viewCSV extends StatefulWidget {
  final List<List<dynamic>> csvFileList;
  final String csvFilePath;

  const viewCSV({Key? key, required this.csvFileList, required this.csvFilePath})
      : super(key: key);
  @override
  _viewCSVState createState() => _viewCSVState();
}

class _viewCSVState extends State<viewCSV> {
  TextEditingController editingController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _valueController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  String idValue = "";
  String scoreValue = "";
  String searchString = "";
  int currentIndex = 0;
  
 Future<void> _addNewRecordDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new record'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                onChanged: (value) {
                  setState(() {
                    idValue = value;
                  });
                },
                controller: _idController,
                decoration: InputDecoration(
                  labelText: "Student ID",
                  hintText: "Enter Student ID"
                  ),
                keyboardType: TextInputType.number,
                ),
                TextField(
                onChanged: (value) {
                  setState(() {
                    scoreValue = value;
                  });
                },
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: "Score",
                  hintText: "Enter Score"
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
                    idValue = "";
                    scoreValue = "";
                    _idController.clear();
                    _valueController.clear();
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                    widget.csvFileList.add([idValue,scoreValue]);
                    fileManage.writeListDatatoFile(widget.csvFileList, widget.csvFilePath);
                  setState(() {
                    Navigator.pop(context);
                    idValue = "";
                    scoreValue = "";
                    _idController.clear();
                    _valueController.clear();
                  });
                },
              ),

            ],
          );
        });
  }

 Future<void> _editRecordDialog(BuildContext context) async {
    _idController.text = widget.csvFileList[currentIndex][0].toString();
    _valueController.text = widget.csvFileList[currentIndex][1].toString();
    idValue = _idController.text;
    scoreValue = _valueController.text;
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
                    idValue = value;
                  });
                },
                controller: _idController,
                decoration: InputDecoration(hintText: "Enter Student ID"),
                ),
                TextField(
                onChanged: (value) {
                  setState(() {
                    scoreValue = value;
                  });
                },
                controller: _valueController,
                decoration: InputDecoration(hintText: "Enter Score"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    idValue = "";
                    scoreValue = "";
                    _idController.clear();
                    _valueController.clear();
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                    widget.csvFileList.removeAt(currentIndex);
                    widget.csvFileList.insert(currentIndex, [idValue, scoreValue]);
                    fileManage.writeListDatatoFile(widget.csvFileList, widget.csvFilePath);
                  setState(() {
                    Navigator.pop(context);
                    idValue = "";
                    scoreValue = "";
                    _idController.clear();
                    _valueController.clear();
                  });
                },
              ),

            ],
          );
        });
  }

 Future<void> _deleteDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete this record?'),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                    widget.csvFileList.removeAt(currentIndex);
                    fileManage.writeListDatatoFile(widget.csvFileList, widget.csvFilePath);
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),

            ],
          );
        });
  }

  void _showPopupMenu(Offset offset, int index) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
        items: [
          PopupMenuItem(
             value: 1,
            child: Text("Edit"),
            onTap: () {
              setState(()
              {
                currentIndex = index;
              });
              Future<void>.delayed(
                const Duration(),  // OR const Duration(milliseconds: 500),
                () => _editRecordDialog(context),
              );
            },
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Delete"),
            onTap: () {
              setState(()
              {
                currentIndex = index;
              });
              Future<void>.delayed(
                const Duration(),  // OR const Duration(milliseconds: 500),
                () => _deleteDialog(context),
              );
            },
          ),
        ],
        elevation: 8.0,
      ).then((value){

      if(value!=null)
       print(value);

       });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(widget.csvFilePath.split('/').last),
    ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState((){
                searchString = value;
                });
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
            Row(
              children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    _addNewRecordDialog(context);
                  }, 
                  child: Text("Add")
                ),
              ),
          ),  
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                        file: File(widget.csvFilePath),
                        fileList: widget.csvFileList
                      )
                    ),
                    (Route<dynamic> route) => false
                    );
                  }, 
                  child: Text("Use this file")
                ),
              ),
          ),  
         Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () async {
                    await Share.shareFiles([widget.csvFilePath]);
                  }, 
                  child: Text("Export to CSV")
                ),
              ),
          ),  
          ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.csvFileList.length,
                itemBuilder: (context, index) {
                  return widget.csvFileList[index][0].toString().contains(searchString) || widget.csvFileList[index][1].toString().contains(searchString)
                  ? Card(
                      child: GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          _showPopupMenu(details.globalPosition, index);
                        },
                        child: ListTile(
                          title: Text(
                            "Student ID: " + widget.csvFileList[index][0].toString() + "\nScore: " + widget.csvFileList[index][1].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ),
                      )
                    )
                  : Container();
                }
              )
          )
        //   Expanded(
        //     child: FutureBuilder(
        //     future: fileManage.displayCSVData(widget.csvFilePath),
        //     builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        //     print(snapshot.data.toString());
        //       if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //         return Center(
        //           child: 
        //             Text('You don\'t have any record.',
        //             style: TextStyle(fontSize: 20),),
        //         );
        //       }
        //       print('${snapshot.data!.length} ${snapshot.data}');
        //       if (snapshot.data!.length == 0) {
        //         return Center(
        //           child: Text('Can\'t Load CSV File.'),
        //         );
        //       }
        //       if(snapshot.hasData) {
        //           setState(() {
        //           csvData = snapshot.data!;
        //           log(csvData.toString());
        //         });
        //       }
        //       return ListView.builder(
        //         itemCount: snapshot.data!.length,
        //         itemBuilder: (context, index) {
        //           return snapshot.data![index][0].toString().contains(searchString) || snapshot.data![index][1].toString().contains(searchString)
        //           ? Card(
        //               child: ListTile(
        //                 onTap: () {
        //                 },
        //                 title: Text(
        //                   "Student ID: " + snapshot.data![index][0].toString() + "\nScore: " + snapshot.data![index][1].toString(),
        //                   style: TextStyle(fontWeight: FontWeight.bold),
        //                 )
        //               ),
        //             )
        //           : Container();
        //         }
        //       );
        //   },
        //     ),
        // ),
        ],
      )
    );
  }
}