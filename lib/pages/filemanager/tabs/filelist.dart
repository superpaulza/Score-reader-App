import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:score_scanner/modules/file/fileListView.dart';
import 'package:score_scanner/modules/file/getfileList.dart';

class fileList extends StatelessWidget {
const fileList({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fileListView(AllCSVFiles: getFileList().all())
    );
  }
}