import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as IMG;

class imageas {
  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}

class ImageProcessor {
  static Future<void> cropIMG(String srcFilePath, int x, int y, int w, int h) async {
  var bytes = await File(srcFilePath).readAsBytes();
  IMG.Image? src = IMG.decodeImage(bytes);
  IMG.Image destImage = IMG.copyCrop(src!, x, y, w, h);
  var jpg = IMG.encodeJpg(destImage);
    await File(srcFilePath).writeAsBytes(jpg);
  }

  static Future cropSquare(String srcFilePath, String destFilePath, bool flip) async {
    var bytes = await File(srcFilePath).readAsBytes();
    IMG.Image? src = IMG.decodeImage(bytes);

    var cropSize = min(src!.width, src.height);
    int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

    IMG.Image destImage =
      IMG.copyCrop(src, offsetX, offsetY, cropSize, cropSize);

    if (flip) {
        destImage = IMG.flipVertical(destImage);
    }

    var jpg = IMG.encodeJpg(destImage);
    await File(destFilePath).writeAsBytes(jpg);
  }
}