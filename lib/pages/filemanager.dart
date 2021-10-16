import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:score_scanner/modules/drawer.dart';

class fileManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: PublicDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}