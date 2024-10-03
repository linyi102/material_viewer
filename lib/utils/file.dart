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

  static String getReadableSize(int size) {
    int kb = 1024, mb = 1048576, gb = 1073741824;
    if (size < kb) {
      return "${size}B";
    } else if (size < mb) {
      return "${(size / kb).toStringAsFixed(2)}KB";
    } else if (size < gb) {
      return "${(size / mb).toStringAsFixed(2)}MB";
    } else {
      return "${(size / gb).toStringAsFixed(2)}GB";
    }
  }
}
