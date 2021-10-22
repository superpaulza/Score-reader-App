import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:score_scanner/modules/drawer.dart';

class deBugScreen extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Developer Mode')),
      drawer: PublicDrawer(),
      body: Center(
        child:
            ElevatedButton(
              onPressed: () {generateCSVFile();}, 
              child: Text(
                'Generate CSV', 
                style: TextStyle(fontSize: 22)
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              )
            )
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