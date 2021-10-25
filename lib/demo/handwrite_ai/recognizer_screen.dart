import 'package:flutter/material.dart';
import 'package:score_scanner/demo/handwrite_ai/constants.dart';
import 'package:score_scanner/demo/handwrite_ai/drawing_painter.dart';
import 'package:score_scanner/demo/handwrite_ai/brain.dart';

class RecognizerScreen extends StatefulWidget {
  RecognizerScreen({Key? key}) : super(key: key);

  @override
  _RecognizerScreen createState() => _RecognizerScreen();
}

class _RecognizerScreen extends State<RecognizerScreen> {
  List<Offset> points = [];
  AppBrain brain = AppBrain();

  void _cleanDrawing() {
    setState(() {
      points = [];
    });
  }

  @override
  void initState() {
    super.initState();
    brain.loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Model Example"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.red,
                alignment: Alignment.center,
                child: Text('Header'),
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  width: 3.0,
                  color: Colors.blue,
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox? renderBox = context.findRenderObject() as RenderBox?;
                        points.add(
                            renderBox!.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox? renderBox = context.findRenderObject() as RenderBox?;
                        points.add(
                            renderBox!.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanEnd: (details) async {
                      List? predictions = await brain.processCanvasPoints(points);
                      print(predictions);
                      setState(() {});
                    },
                    child: ClipRect(
                      child: CustomPaint(
                        size: Size(kCanvasSize, kCanvasSize),
                        painter: DrawingPainter(
                          offsetPoints: points,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text('Footer'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cleanDrawing();
        },
        tooltip: 'Clean',
        child: Icon(Icons.delete),
      ),
    );
  }
}
