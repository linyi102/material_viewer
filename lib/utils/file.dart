import 'dart:io';

import 'package:material_viewer/enums/file_type.dart';

class FileUtil {
  static FileType parseFileType(String name) {
    name = name.toLowerCase();
    for (final fileType in FileType.values) {
      if (fileType.suffixes.indexWhere((suffix) => name.endsWith(suffix)) >=
          0) {
        return fileType;
      }
    }
    return FileType.unknown;
  }

  static bool hasNoParentDirectory(String path) {
    final directory = Directory(path);
    final parent = directory.parent;
    return parent.path == '.' || parent.path == directory.path;
  }
}
