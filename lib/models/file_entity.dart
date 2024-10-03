import 'dart:io';

import 'package:material_viewer/enums/file_type.dart';
import 'package:material_viewer/utils/file.dart';
import 'package:path/path.dart' as p;

class FileEntity {
  final String path;
  final String name;
  final FileType type;
  final FileStat stat;
  final FileSystemEntity raw;

  bool get isDirectory => type == FileType.dir || isDisk;
  bool get isDisk => type == FileType.disk;
  bool get isFile => !isDirectory;

  const FileEntity({
    required this.path,
    required this.name,
    required this.type,
    required this.stat,
    required this.raw,
  });

  factory FileEntity.fromPath(String path) {
    String name = p.basename(path);
    if (name.endsWith('\\')) name = name.substring(0, name.length - 1);
    FileType type;
    FileSystemEntity raw;
    FileStat stat;
    if (FileSystemEntity.isDirectorySync(path)) {
      type = FileType.dir;
      raw = Directory(path);
      stat = raw.statSync();
    } else {
      type = FileUtil.parseFileType(name);
      raw = File(path);
      stat = raw.statSync();
    }
    return FileEntity(path: path, name: name, type: type, stat: stat, raw: raw);
  }
}
