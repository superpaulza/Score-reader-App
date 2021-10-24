import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:score_scanner/pages/csv/viewcsv.dart';

class fileListView extends StatefulWidget {
  final Future<List<FileSystemEntity>> AllCSVFiles;

  const fileListView({Key? key, required this.AllCSVFiles}) : super(key: key);

  @override
  _fileListViewState createState() => new _fileListViewState();
}

class _fileListViewState extends State<fileListView> {
    TextEditingController _editingController = TextEditingController();
    @override
    void initState() {
      super.initState();
  }
  
  void filterSearchResults(String query) async {
    List<FileSystemEntity> CSVFiles = await widget.AllCSVFiles;
    List<FileSystemEntity> SearchList;
    setState(() {
      SearchList = CSVFiles
          .where((string) => string.path.split('/').last.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
        return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: _editingController,
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
                itemBuilder: (context, index) => Card(
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
                ),
                itemCount: snapshot.data!.length,
              );
              },
            ),
            )
          ]
        )
      );
  }
}