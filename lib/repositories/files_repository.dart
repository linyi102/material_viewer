import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_viewer/models/directory_entity.dart';
import 'package:material_viewer/models/file_entity.dart';
import 'package:material_viewer/utils/windows.dart';

class FilesRepository {
  Future<List<DirectoryEntity>> getDisks() async {
    final disks = await WindowsUtil.getDisks();
    return disks.map((e) => DirectoryEntity.fromPath(e, isDisk: true)).toList();
  }

  Future<List<FileEntity>> getFiles(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      // TODO
      throw 'Directory not found!';
    }
    final files =
        directory.listSync().map((e) => FileEntity.fromPath(e.path)).toList();
    files.sort((a, b) {
      if ((a.isDirectory && b.isDirectory) || (a.isFile && b.isFile)) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else {
        return a.isDirectory ? -1 : 1;
      }
    });
    return files;
  }
}

final filesRepositoryProvider = StateProvider<FilesRepository>((ref) {
  return FilesRepository();
});
