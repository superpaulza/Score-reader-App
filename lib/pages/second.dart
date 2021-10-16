import 'package:flutter/material.dart';

import 'package:score_scanner/modules/drawer.dart';

class SecondPage extends StatelessWidget {
  static String route = "second";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Route"),
      ),
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