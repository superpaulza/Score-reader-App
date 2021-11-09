import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' hide Image;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:tflite/tflite.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class AppBrain {
  //load models
  Future loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
        model: "assets/models/model_eff.tflite",
        // model: "assets/models/converted_mnist_model.tflite",
        labels: "assets/models/labels.txt",
      );
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future<List?> preProcessImage(File imageData) async {
    //Convert color image to grayscale image
    var bytes = await imageData.readAsBytes();
    im.Image? src = im.decodeImage(bytes);
    src = im.grayscale(src!);
    src = im.sobel(src);

    final appDir = await syspaths.getTemporaryDirectory();
    File file = File('${appDir.path}/img.jpg');

    var jpg = im.encodeJpg(src);
    await File(file.path).writeAsBytes(jpg);
    
    return predictImage(file.path);
  }

  Future<List?> predictImage(String image) async {
    List<dynamic>? data = await Tflite.detectObjectOnImage(
      path: image,
      threshold: 0.3,
      numResultsPerClass: 10,
    );
    data?.sort((a, b) => a['rect']['x'].compareTo(b['rect']['x']));
    log(data.toString());
    return data;
  }
}

  // Future<List?> predictImage(File imageData) async {
  //   return await Tflite.runModelOnImage(
  //     path: imageData.path
  //   );
  // }

  // Future<List?> predictImage(File imageData) async {
  //   final bytes = await imageData.readAsBytes();
  //   final im.Image? image = im.decodeImage(bytes);
  //   return await Tflite.runModelOnBinary(
  //     binary: imageToByteListFloat32(image!, image.width, image.height),
  //   );
  // }

//   Uint8List imageToByteListFloat32(im.Image image, int widgth, int height) {
//     var convertedBytes = Float32List(widgth * height);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;
//     for (var i = 0; i < widgth; i++) {
//       for (var j = 0; j < height; j++) {
//         var pixel = image.getPixel(j, i);
//         buffer[pixelIndex++] =
//             (im.getRed(pixel) + im.getGreen(pixel) + im.getBlue(pixel)) /
//                 3 /
//                 255.0;
//       }
//     }
//     return convertedBytes.buffer.asUint8List();
//   }

//   double convertPixel(int color) {
//     return (255 -
//         (((color >> 16) & 0xFF) * 0.299 +
//             ((color >> 8) & 0xFF) * 0.587 +
//             (color & 0xFF) * 0.114)) /
//         255.0;
//   }

// }