import 'package:flutter/material.dart';
import 'package:score_scanner/modules/fileListView.dart';
import 'package:score_scanner/modules/getfileList.dart';

class fileList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fileListView(AllCSVFiles: getFileList().all())
    );
  }
}