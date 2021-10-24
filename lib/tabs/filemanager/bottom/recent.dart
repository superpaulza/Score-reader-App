import 'dart:io';

import 'package:flutter/material.dart';
import 'package:score_scanner/modules/fileListView.dart';
import 'package:score_scanner/modules/getfileList.dart';

class recentFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fileListView(AllCSVFiles: getFileList().byLastModifiy()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cam'),
        child: const Icon(Icons.camera_alt),
      )
    );
  }
}