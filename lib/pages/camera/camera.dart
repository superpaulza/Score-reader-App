// A screen that allows users to take a picture using a given camera.
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:score_scanner/pages/camera/display.dart';
import 'package:score_scanner/modules/drawer.dart';
import 'package:score_scanner/main.dart';

class TakePictureScreen extends StatefulWidget {

  const TakePictureScreen({Key? key}) : super(key: key);

@override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> 
  with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  var isCameraReady = false;
  XFile? imgFile;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras[0],
      // Define the resolution to use.
      ResolutionPreset.max,

      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller!.initialize();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
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
          ? _controller!.initialize()
          : null; //on pause camera disposed so we need call again "issue is only for android"
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
            // If the Future is complete, display the preview.
            var camera = _controller!.value;
            final size = MediaQuery.of(context).size;
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

  captureImageButton(BuildContext context) {
    return Expanded(
      child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: InkWell(
                  onTap: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                    // Ensure that the camera is initialized.
                    await _initializeControllerFuture;

                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    _controller!.takePicture().then((file) => {
                      setState(() {
                        imgFile = file;
                      }),
                      if(mounted) {
                        // If the picture was taken, display it on a new screen.
                        Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            imageData: file
                          )
                        ))
                      }
                    });
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    } 
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }

  Widget mainDrawer(){
    return Positioned(
                  left: 10,
                  top: 20,
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
    return Scaffold(
      key: scaffoldKey,
      drawer: PublicDrawer(),
      body: Container(
        child: Stack(
          children: <Widget>[
            Stack(children: [
                    Center(child: cameraPreview(context))
                  ],),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
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
          mainDrawer(),
          ],
        ),
      ),   
    );
  }
}