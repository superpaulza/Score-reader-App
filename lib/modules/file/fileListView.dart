import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:score_scanner/pages/csv/viewcsv.dart';

class fileListView extends StatefulWidget {
  final Future<List<FileSystemEntity>> AllCSVFiles;
  
  const fileListView({Key? key, required this.AllCSVFiles}) : super(key: key);
  @override
  _fileListViewState createState() => _fileListViewState();
}

class _fileListViewState extends State<fileListView> {
  TextEditingController editingController = TextEditingController();

  @override
  initState() {
    super.initState();
  }
  String searchString = "";


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
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return snapshot.data![index].path.split('/').last.contains(searchString)
                    ? Card(
                        child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                              viewCSV(csvFilePath: snapshot.data![index].path),
                            ),
                          );
                        },
                        title: Text(
                          snapshot.data![index].path.split('/').last,
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