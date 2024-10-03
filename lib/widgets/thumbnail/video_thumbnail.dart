import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
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
  final logTag = 'VideoThumbnail';

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
    final cacheDir = await getApplicationCacheDirectory();
    final plugin = FcNativeVideoThumbnail();
    const format = 'jpeg';
    final stat = await widget.file.stat();
    final mTime = stat.modified.millisecondsSinceEpoch;
    final byteSize = stat.size;
    final nameHash =
        sha1.convert(utf8.encode(p.basename(widget.file.path))).toString();
    final nameShortHash = nameHash.substring(0, 8.clamp(0, nameHash.length));
    final outputDirPath = p.join(cacheDir.path, 'thumbnail', 'video');
    final fileAndThumbnailInfo =
        '文件路径：${widget.file.path}\n缩略图路径：$outputDirPath';

    try {
      final output = p.join(
        outputDirPath,
        '${nameShortHash}_${mTime}_$byteSize.$format',
      );
      if (await File(output).exists()) {
        logger.info('获取视频缓存缩略图\n$fileAndThumbnailInfo', tag: logTag);
        return output;
      }
      await Directory(outputDirPath).create(recursive: true);
      final success = await plugin.getVideoThumbnail(
        srcFile: widget.file.path,
        destFile: output,
        width: 300,
        height: 300,
        format: format,
        quality: 90,
      );
      success
          ? logger.info('生成视频缓存缩略图成功\n$fileAndThumbnailInfo')
          : logger.error('生成视频缓存缩略图失败\n$fileAndThumbnailInfo');
      return success ? output : null;
    } catch (err, stack) {
      logger.error('生成视频缩略图报错\n$fileAndThumbnailInfo',
          error: err, stackTrace: stack, tag: logTag);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(thumbnail);
  }
}
