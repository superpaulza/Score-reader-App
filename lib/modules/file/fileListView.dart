import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:score_scanner/pages/csv/editablecsv.dart';

import 'package:score_scanner/pages/csv/viewcsv.dart';
import 'package:share/share.dart';

class fileListView extends StatefulWidget {
  final Future<List<FileSystemEntity>> AllCSVFiles;
  
  const fileListView({Key? key, required this.AllCSVFiles}) : super(key: key);
  @override
  _fileListViewState createState() => _fileListViewState();
}

class _fileListViewState extends State<fileListView> {
  TextEditingController editingController = TextEditingController();
  TextEditingController fileEditingController = TextEditingController();

  @override
  initState() {
    super.initState();
  }
  String searchString = "";
  late File file;
  String valueText = "";
  List<FileSystemEntity> fileSystem = [];
  var currentIndex = 0;
  String fileName = "";
  String filePath = "";
  late Offset detail;

  TextEditingController _renameController = TextEditingController();

  Future<void> _renameDialog(BuildContext context) async {
    _renameController.text = fileName;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Rename File'),
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
                  file = await fileManage.renameFile(File(filePath), fileName);
                  setState(() {
                    fileSystem.removeAt(currentIndex);
                    fileSystem.insert(currentIndex, file);
                    Navigator.pop(context);
                    fileName = "";
                    _renameController.clear();
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
            title: Text('Delete this file?'),
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
                onPressed: () async {
                    await fileManage.deleteFile(File(filePath));
                  setState(() {
                    fileSystem.removeAt(currentIndex);
                    Navigator.pop(context);
                  });
                },
              ),

            ],
          );
        });
  }

  void _showPopupMenu(Offset offset, int index, String path) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
        items: [
          PopupMenuItem(
             value: 1,
            child: Text("Rename"),
            onTap: () {
              setState(()
              {
                filePath = path;
                currentIndex = index;
              });
              Future<void>.delayed(
                const Duration(),  // OR const Duration(milliseconds: 500),
                () => _renameDialog(context),
              );
            },
          ),
          PopupMenuItem(
             value: 1,
            child: Text("Export"),
            onTap: () async {
              setState(()
              {
                currentIndex = index;
              });
            },
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Delete"),
            onTap: () {
              setState(()
              {
                filePath = path;
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Create new file'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: fileEditingController,
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
                    valueText = "";
                    fileEditingController.clear();
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  file = await fileManage.makeCSV(valueText);
                  setState(() {
                    fileSystem.add(file);
                    Navigator.pop(context);
                    file = file;
                    valueText = "";
                    fileEditingController.clear();
                  });
                },
              ),

            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
        return Container(
        child: Column(
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
            padding: const EdgeInsets.all(10.0),
            child: 
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: ()  {
                    _displayTextInputDialog(context);
                  }, 
                  child: Text("+ Create new file")
                ),
              ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: 
          //     Align(
          //       alignment: Alignment.centerLeft,
          //       child: ElevatedButton(
          //         onPressed: () {

          //         }, 
          //         child: Text("Import File")
          //       ),
          //     ),
          // ),  
            ],
          ),
            Expanded(
              child: FutureBuilder(
                future: widget.AllCSVFiles,
                builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error,
                            size: 100,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "You don\'t have any files.\n Start create score record\n by pressing ",
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.camera_alt, size: 20),
                                ),
                                TextSpan(
                                  text: " Camera",       
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )
                  );
                }
                print('${snapshot.data!.length} ${snapshot.data}');
                if (snapshot.data!.length == 0) {
                  return Center(
                    child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error,
                            size: 100,
                          ),
                          Text('No CSV File found from Local Storage.',
                            style: TextStyle(fontSize: 20),
                      ),
                        ],
                      )
                  );
                }
                fileSystem = snapshot.data!;
                return ListView.builder(
                  itemCount: fileSystem.length,
                  itemBuilder: (context, index) {
                    return fileSystem[index].path.split('/').last.contains(searchString)
                    ? GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          setState(() {
                            fileName = (fileSystem[index].path.split('/').last).split('.').first;
                            detail = details.globalPosition;
                          });
                        },
                        onLongPress: () {
                          HapticFeedback.mediumImpact();
                          _showPopupMenu(detail, index, fileSystem[index].path);
                        },
                      child: Card(
                        child: ListTile(
                        onTap: () async {
                          List<List<dynamic>> dataList = await fileManage.displayCSVData(fileSystem[index].path);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                              viewCSV(
                                csvFileList: dataList,
                                csvFilePath: fileSystem[index].path,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.file_copy),
                        title: Text(
                          (fileSystem[index].path.split('/').last).split('.').first,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "lastModified: " + fileSystem[index].statSync().modified.toString()
                          )
                        ),
                      ),
                    )
                    : Container();
                  }
                );
              },
            ),
            )
          ]
        )
      );
  }
}