import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/pages/filemanager/tabs/filelist.dart';
import 'package:score_scanner/pages/filemanager/tabs/recent.dart';

class fileManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
    child: Scaffold(
      appBar: AppBar(
        title: Text('File Manager'),
        bottom: TabBar(
          tabs: [
            Tab(
              text: 'Recent',
              icon: Icon(Icons.folder_rounded),
            ),
            Tab(
              text: 'File List',
              icon: Icon(Icons.list),
            ),
          ],
        ),
      ),
      drawer: PublicDrawer(),
      body: TabBarView(
        children: [
          recentFile(), 
          fileList()
        ],
      ),
    )
    );
  }
}