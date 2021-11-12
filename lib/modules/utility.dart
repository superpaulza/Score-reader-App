import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as IMG;
import 'dart:typed_data';

class imageas {
  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}

class fileManage {
  static Future<File> makeCSV(String name) async {
    List<List<dynamic>> data = [];
    String csvData = ListToCsvConverter().convert(data);
    String directory = (await getApplicationSupportDirectory()).path;
    String filePath = '$directory/$name.csv';
    File tempfile = File(filePath);
    await tempfile.writeAsString(csvData);
    return tempfile;
  }
  static Future<List<List<dynamic>>> displayCSVData(String path) async { 
    final csvFile = File(path).openRead();   
    return await csvFile
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .toList();


  }

  static Future<void> writeListDatatoFile (List<List<dynamic>> yourListOfLists, String filePath) async {
    String csv = const ListToCsvConverter().convert(yourListOfLists);
    File file = await File(filePath);
    file.writeAsString(csv);    
  }
}

class ImageProcessor {
  // ImageProcessor.cropIMG(imageData.path, 180, 400, 320, 320)
  static Future<File> cropIMG(String srcFilePath, int x, int y, int w, int h) async {
  var bytes = await File(srcFilePath).readAsBytes();
  IMG.Image? src = IMG.decodeImage(bytes);
  IMG.Image destImage = IMG.copyCrop(src!, x, y, w, h);
  var jpg = IMG.encodeJpg(destImage);
    await File(srcFilePath).writeAsBytes(jpg);
  return File(srcFilePath);
  }

  static Future<File> cropSquare(String srcFilePath, bool flip) async {
    File? croppedFile;
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
    croppedFile = await File(srcFilePath).writeAsBytes(jpg);
    return  croppedFile;
  }
  
  static Future<File?> cropImageDialog(String imageFile) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
    ));
    return croppedFile;
  }
}