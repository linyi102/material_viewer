import 'package:material_viewer/enums/file_type.dart';
import 'package:material_viewer/models/file_entity.dart';

class DirectoryEntity extends FileEntity {
  const DirectoryEntity({
    required super.path,
    required super.name,
    required super.type,
    required super.stat,
    required super.raw,
  });

  factory DirectoryEntity.fromPath(
    String path, {
    bool isDisk = true,
  }) {
    final file = FileEntity.fromPath(path);
    return DirectoryEntity(
      path: path,
      name: file.name,
      type: isDisk ? FileType.disk : file.type,
      stat: file.stat,
      raw: file.raw,
    );
  }
}
