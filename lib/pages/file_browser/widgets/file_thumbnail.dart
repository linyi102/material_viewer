import 'dart:io';

import 'package:material_viewer/enums/file_type.dart';
import 'package:material_viewer/widgets/thumbnail/video_thumbnail.dart';
import 'package:flutter/material.dart';

class FileThumbnail extends StatefulWidget {
  const FileThumbnail({super.key, required this.file, required this.type});
  final FileSystemEntity file;
  final FileType type;

  @override
  State<FileThumbnail> createState() => _FileThumbnailState();
}

class _FileThumbnailState extends State<FileThumbnail> {
  @override
  Widget build(BuildContext context) {
    final file = widget.file is File ? widget.file as File : null;
    if (file == null) return _buildIcon();

    switch (widget.type) {
      case FileType.video:
        return VideoThumbnail(
            file: file,
            builder: (thumbnail) {
              if (thumbnail == null) return _buildIcon();
              return Image.file(thumbnail, fit: BoxFit.cover);
            });
      case FileType.image:
        return Image.file(file, cacheWidth: 200, fit: BoxFit.cover);
      default:
        return _buildIcon();
    }
  }

  _buildIcon() =>
      FittedBox(child: Icon(widget.type.icon, color: widget.type.color));
}
