import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_scanner/modules/file/fileListView.dart';
import 'package:score_scanner/modules/file/getfileList.dart';

class recentFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fileListView(AllCSVFiles: getFileList().byLastModifiy()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pushNamed(context, '/cam');
        },
        child: const Icon(Icons.camera_alt),
      )
    );
  }
}