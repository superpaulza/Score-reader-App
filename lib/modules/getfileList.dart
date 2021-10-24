
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class getFileList {
  Future<List<FileSystemEntity>> all() async {
    String localDirectory = (await getApplicationSupportDirectory()).path;
    String directoryPath = '$localDirectory/';
    Directory myDirectory = Directory(directoryPath);
    List<FileSystemEntity> listCSVFiles = myDirectory.listSync(recursive: true, followLinks: false);
    return listCSVFiles;
  }

  Future<List<FileSystemEntity>> byLastAccess() async{
    List<FileSystemEntity> listCSVFiles = await all();
    listCSVFiles.sort((a, b) {
      return FileStat.statSync(b.path).accessed.compareTo(FileStat.statSync(a.path).accessed);
    });
    return listCSVFiles;
  }

  Future<List<FileSystemEntity>> byLastChange() async{
    List<FileSystemEntity> listCSVFiles = await all();
    listCSVFiles.sort((a, b) {
      return FileStat.statSync(b.path).changed.compareTo(FileStat.statSync(a.path).changed);
    });
    return listCSVFiles;
  }

  Future<List<FileSystemEntity>> byLastModifiy() async{
    List<FileSystemEntity> listCSVFiles = await all();
    listCSVFiles.sort((a, b) {
      return FileStat.statSync(b.path).modified.compareTo(FileStat.statSync(a.path).modified);
    });
    return listCSVFiles;
  }

  Future<List<FileSystemEntity>> bySize() async{
    List<FileSystemEntity> listCSVFiles = await all();
    listCSVFiles.sort((a, b) {
      return FileStat.statSync(b.path).size.compareTo(FileStat.statSync(a.path).size);
    });
    return listCSVFiles;
  }
}

