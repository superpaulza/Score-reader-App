// A screen that allows users to take a picture using a given camera.
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:score_scanner/modules/utility.dart';

import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/main.dart';
import 'package:score_scanner/pages/camera/preview.dart';
import 'package:score_scanner/pages/camera/preview.dart';
import 'package:score_scanner/pages/csv/viewcsv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakePictureScreen extends StatefulWidget {
  final File file;
  final List<List<dynamic>> fileList;

  const TakePictureScreen({
    Key? key, 
    required this.file,
    required this.fileList
    }) : super(key: key);

@override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> 
  with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  var isCameraReady = false;
  File? imgFile;
  bool _toggleFlash = false;
  IconData _icFlash = Icons.flashlight_off_rounded;
  bool _isCrop = false;
  SharedPreferences? preferences;
  bool singleTap = true;

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _isCrop = (preferences!.getBool('isCrop') ?? false);
    });
  }


  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
     initializePreference().whenComplete(() {
       setState(() {});
     });
    WidgetsBinding.instance!.addObserver(this);
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras[0],
      // Define the resolution to use.
      ResolutionPreset.high,

      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller?.initialize();


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeControllerFuture = _controller != null 
          ? _controller?.initialize()
          : null; 
    //on pause camera disposed so we need call again "issue is only for android"
    if(!mounted)
      return;
    setState(() {
      isCameraReady = true;
    });
    }
  }

  Widget cameraPreview(context) {
        // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // _controller?.setFlashMode(FlashMode.off);
            _controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
            // If the Future is complete, display the preview. 
            var size = MediaQuery.of(context).size;
            var camera = _controller!.value;
            var scale = size.aspectRatio * camera.aspectRatio;
            if(scale < 1) scale = 1 / scale;
            return Transform.scale(
                      scale: scale,
                      child: CameraPreview(_controller!),
                    );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
    );
  }

  flashButton() {
    return InkWell(
        borderRadius:
            BorderRadius.all(Radius.circular(50.0)),
        onTap: () {
            if (!_toggleFlash) {
              setState(() {
                _controller?.setFlashMode(FlashMode.always);
                _icFlash = Icons.flashlight_on_rounded;
                _toggleFlash = true;
              });
            } else {
              setState(() {
                _controller?.setFlashMode(FlashMode.off);
                _icFlash = Icons.flashlight_off_rounded;
                _toggleFlash = false;
              });
            }
        },
        child: Container(
          alignment: Alignment.bottomLeft,
          child: Icon(
            _icFlash,
          )
          ),
        );
  }

  Future<XFile?> takePicture() async {
    await initializePreference();
    final CameraController? cameraController = _controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      File? temp;
      XFile file = await cameraController.takePicture();
      await ImageProcessor.cropSquare(file.path, false);
      temp = File(file.path);
      if(_isCrop) {
        try {
          temp = await ImageProcessor.cropImageDialog(file.path);
          return XFile(temp!.path);
        } catch(e) {
          print(e);
        }
      }
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Loading"),
          ],
        ),
      );
    },
  );
  }



  captureImageButton(BuildContext context) {
    return Expanded(
      child: 
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: InkWell(
                  onTap: () {
                    _onLoading();
                    if (singleTap) {
                      // Do something here
                      setState(() {
                      singleTap = false; // update bool
                      });
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    // Ensure that the camera is initialized.
                    HapticFeedback.selectionClick();
                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    takePicture().then((file) => {
                      setState(() {
                        imgFile = File(file!.path);
                      }),

                    
                    
                    if(mounted) {
                        // If the picture was taken, display it on a new screen.
                          Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PreviewScreen(
                              imageData: File(file!.path),
                              fileData: widget.file,
                              csvfileList: widget.fileList,
                            )
                          ))
                      }
                    });
                    }
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
                )
                ),
              ),
            );
  }

  AddtoListButton(BuildContext context) {
  return Expanded(
    child:           
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 60, right: 50),
            child: InkWell(
              child: IconButton(
                icon: Icon(
                  Icons.library_books,
                  size: 50,
                  ),
                onPressed: () async {
                  List<List<dynamic>> dataList = await fileManage.displayCSVData(widget.file.path);
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => viewCSV(
                      csvFilePath: widget.file.path,
                      csvFileList: dataList,
                    )
                  ));
                },
            )
          )
        )
      )
    );
  }

  Widget mainDrawer(){
    return Positioned(
                  left: 10,
                  top: 25 ,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => {
                      scaffoldKey.currentState!.openDrawer(),
                    }
                  ),
                );
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      drawer: PublicDrawer(),
      body: Container(
        child: Stack(
          children: <Widget>[
            Stack(children: [
                    Center(child: cameraPreview(context))
                  ],),
            Container(
              decoration: ShapeDecoration(
                shape: _ScannerOverlayShape(
                  borderColor: Colors.lightGreen,
                  borderWidth: 3.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    captureImageButton(context),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      AddtoListButton(context),
                  ],
              ),
            ),
          mainDrawer(),
          ],
        ),
      ),   
    );
  }
}

class _ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;

  _ScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 1.0,
    this.overlayColor = const Color(0x88000000),
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(10.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    const lineSize = 30;

    final width = rect.width;
    final borderWidthSize = width * 10 / 100;
    final height = rect.height;
    final borderHeightSize = height - (width - borderWidthSize);
    final borderSize = Size(borderWidthSize / 2, borderHeightSize / 2);

    var paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;
      
    canvas
      ..drawRect(
        Rect.fromLTRB(rect.left, rect.top, rect.right, borderSize.height + rect.top),
        paint,
      )
      ..drawRect(
        Rect.fromLTRB(rect.left, rect.bottom - borderSize.height, rect.right, rect.bottom),
        paint,
      )
      ..drawRect(
        Rect.fromLTRB(rect.left, rect.top + borderSize.height, rect.left + borderSize.width, rect.bottom - borderSize.height),
        paint,
      )
      ..drawRect(
        Rect.fromLTRB(rect.right - borderSize.width, rect.top + borderSize.height, rect.right, rect.bottom - borderSize.height),
        paint,
      );

    paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final borderOffset = borderWidth / 2;
    final realReact = Rect.fromLTRB(borderSize.width + borderOffset, borderSize.height + borderOffset + rect.top, width - borderSize.width - borderOffset,
        height - borderSize.height - borderOffset + rect.top);

    //Draw top right corner
    canvas
      ..drawPath(
          Path()
            ..moveTo(realReact.right, realReact.top)
            ..lineTo(realReact.right, realReact.top + lineSize),
          paint)
      ..drawPath(
          Path()
            ..moveTo(realReact.right, realReact.top)
            ..lineTo(realReact.right - lineSize, realReact.top),
          paint)
      ..drawPoints(
        PointMode.points,
        [Offset(realReact.right, realReact.top)],
        paint,
      )

      //Draw top left corner
      ..drawPath(
          Path()
            ..moveTo(realReact.left, realReact.top)
            ..lineTo(realReact.left, realReact.top + lineSize),
          paint)
      ..drawPath(
          Path()
            ..moveTo(realReact.left, realReact.top)
            ..lineTo(realReact.left + lineSize, realReact.top),
          paint)
      ..drawPoints(
        PointMode.points,
        [Offset(realReact.left, realReact.top)],
        paint,
      )

      //Draw bottom right corner
      ..drawPath(
          Path()
            ..moveTo(realReact.right, realReact.bottom)
            ..lineTo(realReact.right, realReact.bottom - lineSize),
          paint)
      ..drawPath(
          Path()
            ..moveTo(realReact.right, realReact.bottom)
            ..lineTo(realReact.right - lineSize, realReact.bottom),
          paint)
      ..drawPoints(
        PointMode.points,
        [Offset(realReact.right, realReact.bottom)],
        paint,
      )

      //Draw bottom left corner
      ..drawPath(
          Path()
            ..moveTo(realReact.left, realReact.bottom)
            ..lineTo(realReact.left, realReact.bottom - lineSize),
          paint)
      ..drawPath(
          Path()
            ..moveTo(realReact.left, realReact.bottom)
            ..lineTo(realReact.left + lineSize, realReact.bottom),
          paint)
      ..drawPoints(
        PointMode.points,
        [Offset(realReact.left, realReact.bottom)],
        paint,
      );
  }

  @override
  ShapeBorder scale(double t) {
    return _ScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}

