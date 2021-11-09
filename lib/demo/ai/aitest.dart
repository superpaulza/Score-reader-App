import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:score_scanner/modules/drawer.dart';

import 'package:score_scanner/demo/ai/brain.dart';
import 'package:image/image.dart' as im;

// A widget that displays the picture taken by the user.
class aiTestScreen extends StatefulWidget {
  final File imageData;

  aiTestScreen({Key? key, required this.imageData}) : super(key: key);

  @override
  _aiTestScreenState createState() => _aiTestScreenState();
}

class _aiTestScreenState extends State<aiTestScreen> {
  AppBrain brain = AppBrain();

  @override
  void initState() {
    super.initState();
    brain.loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Result')),
      drawer: PublicDrawer(),
      body: Container(
        child: FutureBuilder<List?>(
          future: brain.preProcessImage(widget.imageData),
          builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Result: ${snapshot.data}'),
                )
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      )
    );
  }
}
