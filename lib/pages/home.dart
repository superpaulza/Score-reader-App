import 'package:flutter/material.dart';
import 'package:score_scanner/modules/drawer.dart';

class HomePage extends StatelessWidget {
  static String route = "home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Scanner Mobile Application'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Take a picture'),
          onPressed: () {
            Navigator.pushNamed(context, '/cam');
          },
        ),
      ),
      drawer: PublicDrawer(),
    );
  }
}