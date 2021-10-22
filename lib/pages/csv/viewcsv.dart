import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class viewCSV extends StatelessWidget {
  final String csvFilePath;

  const viewCSV({Key? key, required this.csvFilePath})
      : super(key: key);
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('CSV File Data'),
    ),
      body: FutureBuilder(
      future: displayCSVData(csvFilePath),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
      print(snapshot.data.toString());
    
    return snapshot.hasData
    //True Condition
    ? Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
      children: snapshot.data
      !.map(
        (data) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            data[0].toString(),
            style: TextStyle(fontSize: 16),
          ),
          Text(
            data[1].toString(),
            style: TextStyle(fontSize: 16),
          ),
          ],
        ),
        ),
      )
      .toList(),
      ),
    )
    //False condition
    : Center(
        child: CircularProgressIndicator(),
      );
    },
    ),
    );
  }
}

Future<List<List<dynamic>>> displayCSVData(String path) async {
  final csvFile = File(path).openRead();
  return await csvFile
  .transform(utf8.decoder)
  .transform(CsvToListConverter())
  .toList();
}