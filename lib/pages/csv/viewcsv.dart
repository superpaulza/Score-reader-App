import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:score_scanner/pages/camera/camera.dart';

class viewCSV extends StatefulWidget {
  final String csvFilePath;

  const viewCSV({Key? key, required this.csvFilePath})
      : super(key: key);
  @override
  _viewCSVState createState() => _viewCSVState();
}

class _viewCSVState extends State<viewCSV> {
  TextEditingController editingController = TextEditingController();
  late final List<List<dynamic>> csvData;

  Future<List<List<dynamic>>> displayCSVData(String path) async {
  final csvFile = File(path).openRead();
  return await csvFile
  .transform(utf8.decoder)
  .transform(CsvToListConverter())
  .toList();
}

  @override
  initState() {
    super.initState();
  }
  String searchString = "";

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

                  }, 
                  child: Text("+ Add record")
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
                    Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                        file: File(widget.csvFilePath),
                      )
                    ));
                  }, 
                  child: Text("Use this file")
                ),
              ),
          ),  
          ],
          ),
          Expanded(
            child: FutureBuilder(
            future: displayCSVData(widget.csvFilePath),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            print(snapshot.data.toString());
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: 
                    Text('You don\'t have any record.',
                    style: TextStyle(fontSize: 20),),
                );
              }
              print('${snapshot.data!.length} ${snapshot.data}');
              if (snapshot.data!.length == 0) {
                return Center(
                  child: Text('Can\'t Load CSV File.'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return snapshot.data![index][0].toString().contains(searchString) || snapshot.data![index][1].toString().contains(searchString)
                  ? Card(
                      child: ListTile(
                        onTap: () {
                        },
                        title: Text(
                          "Student ID: " + snapshot.data![index][0].toString() + "\nScore: " + snapshot.data![index][1].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ),
                    )
                  : Container();
                }
              );
          },
            ),
        ),
        ],
      )
    );
  }
}