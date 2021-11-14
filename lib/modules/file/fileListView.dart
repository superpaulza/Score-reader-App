import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:score_scanner/modules/utility.dart';
import 'package:score_scanner/pages/csv/editablecsv.dart';

import 'package:score_scanner/pages/csv/viewcsv.dart';

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
            padding: const EdgeInsets.all(8.0),
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
                      Text('You don\'t have any files.',
                      style: TextStyle(fontSize: 20),),
                  );
                }
                print('${snapshot.data!.length} ${snapshot.data}');
                if (snapshot.data!.length == 0) {
                  return Center(
                    child: Text('No CSV File found from Local Storage.'),
                  );
                }
                fileSystem = snapshot.data!;
                return ListView.builder(
                  itemCount: fileSystem.length,
                  itemBuilder: (context, index) {
                    return fileSystem[index].path.split('/').last.contains(searchString)
                    ? Card(
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
                        title: Text(
                          fileSystem[index].path.split('/').last,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
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