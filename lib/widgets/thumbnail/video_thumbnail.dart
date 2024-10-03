import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:material_viewer/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class VideoThumbnail extends StatefulWidget {
  const VideoThumbnail({
    super.key,
    required this.file,
    required this.builder,
  });
  final File file;
  final Widget Function(File? thumbnail) builder;

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  File? thumbnail;

  @override
  void initState() {
    super.initState();
    loadThumbnail();
  }

  Future<void> loadThumbnail() async {
    String? path = await getThumbnail();
    if (path != null) {
      thumbnail = File(path);
      if (mounted) setState(() {});
    }
  }

  Future<String?> getThumbnail() async {
    final dir = await getApplicationCacheDirectory();
    final plugin = FcNativeVideoThumbnail();
    final separator = Platform.pathSeparator;
    const format = 'jpeg';
    final output =
        '${dir.path}$separator${p.basename(widget.file.path)}.thumbnail.$format';
    if (await File(output).exists()) {
      // print('[retrieve cache video thumbnail] $output');
      return output;
    }

    try {
      final success = await plugin.getVideoThumbnail(
        srcFile: widget.file.path,
        destFile: output,
        width: 300,
        height: 300,
        format: format,
        quality: 90,
      );
      // print(
      //     '[generate video thumbnail ${success ? 'success' : 'fail'}] $output');
      return success ? output : null;
    } catch (err, stack) {
      logger.error('获取视频缩略图失败 (${widget.file.path})',
          error: err, stackTrace: stack);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(thumbnail);
  }
}
