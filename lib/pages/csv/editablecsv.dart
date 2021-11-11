// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:editable/editable.dart';

// class TablePage extends StatefulWidget {
//   final String csvFilePath;
//   const TablePage({Key? key, required this.csvFilePath})
//   : super(key: key);

//   @override
//   _TablePageState createState() => _TablePageState();
// }
// class _TablePageState extends State<TablePage> {
//  List<List<dynamic>> csvData = <List<dynamic>>[];

//   openFile(filepath) async {
//     File f = new File(filepath);
//     print("CSV to List");
//     final input = f.openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//     setState(() {
//       for(int i = 0; i < fields.length; i++) {
//         csvData.add(fields[i][0].no);
//         csvData.add(fields[i][1].score);
//       }
//       log(csvData.toString());
//     });
//   }
// @override
//   void initState() {
//     super.initState();
//      csvData = List<List<dynamic>>.empty(growable: true);
//      openFile(widget.csvFilePath);
//   }

//   //row data
//   List rows = [
//     {"no": '1', "score":'10'}, 
//     {"no": '2', "score":'11'}, 
//     {"no": '3', "score":'100'}, 
//     {"no": '4', "score":'99.8'}, 
//     {"no": '5', "score":'12.5'}, 
//   ];

//   //Headers or Columns
//   List headers = [
//     {"title":'Std. No', 'index': 1, 'key':'no'},
//     {"title":'Score', 'index': 2, 'key':'score'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Editable(
//         columns: headers, 
//         rows: rows,
//         showCreateButton: true,
//         tdStyle: TextStyle(fontSize: 20),
//         showSaveIcon: false,
//         borderColor: Colors.grey.shade300,
//         onSubmitted: (value){
//          print(value);
//         },
//         onRowSaved: (value){ //added line
//          print(value); //prints to console
//         },
//         ),
//       );
//   }
// }

// Future<List<List<dynamic>>> displayCSVData(String path) async {
//   final csvFile = File(path).openRead();
//   return await csvFile
//   .transform(utf8.decoder)
//   .transform(CsvToListConverter())
//   .toList();
// }