import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:score_scanner/pages/csv/viewcsv.dart';

class fileList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _fileList();
  }
}

class _fileList extends State<fileList> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      color: Colors.grey,
      child: FutureBuilder(
        future: getAllCSVFilesFromStorage(),
      builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('empty');
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
              snapshot.data![index].path,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ),
        ),
        itemCount: snapshot.data!.length,
      );
      },
    ),
    );
  }
}

Future<List<FileSystemEntity>> getAllCSVFilesFromStorage() async {
  String localDirectory = (await getApplicationSupportDirectory()).path;
  String directoryPath = '$localDirectory/';
  Directory myDirectory = Directory(directoryPath);
  List<FileSystemEntity> listCSVFiles = myDirectory.listSync(recursive: true, followLinks: false);
  listCSVFiles.sort((a, b) {
    return b.path.compareTo(a.path);
  });
  return listCSVFiles;
}