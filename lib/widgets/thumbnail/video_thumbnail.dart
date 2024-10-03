import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:material_viewer/utils/logger.dart';

const _logTag = 'VideoThumbnail';

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
    String? path = await _getThumbnail();
    if (path != null) {
      thumbnail = File(path);
      if (mounted) setState(() {});
    }
  }

  Future<String?> _getThumbnail() async {
    final cacheDir = await getApplicationCacheDirectory();
    const format = 'jpeg';
    final stat = await widget.file.stat();
    final mTime = stat.modified.millisecondsSinceEpoch;
    final byteSize = stat.size;
    final nameHash =
        sha1.convert(utf8.encode(p.basename(widget.file.path))).toString();
    final nameShortHash = nameHash.substring(0, 8.clamp(0, nameHash.length));
    final outputDirPath = p.join(cacheDir.path, 'thumbnail', 'video');
    final output = p.join(
      outputDirPath,
      '${nameShortHash}_${mTime}_$byteSize.$format',
    );
    final fileAndThumbnailInfo = '文件路径：${widget.file.path}\n缩略图路径：$output';

    try {
      if (await File(output).exists()) {
        logger.info('获取视频缓存缩略图\n$fileAndThumbnailInfo', tag: _logTag);
        return output;
      }
      await Directory(outputDirPath).create(recursive: true);

      final result = await Process.run(
        p.join(p.dirname(Platform.resolvedExecutable), 'data', 'bin', 'ffmpeg.exe'),
        [
          '-ss',
          '00:00:01.00',
          '-i',
          (widget.file.path),
          '-y',
          '-vf',
          'scale=600:600/a',
          '-vframes',
          '1',
          output,
        ],
      );
      if (result.exitCode == 0) {
        logger.info('生成视频缓存缩略图成功\n$fileAndThumbnailInfo');
        return output;
      } else {
        logger.error('生成视频缓存缩略图失败\n$fileAndThumbnailInfo');
        return null;
      }
    } catch (err, stack) {
      // compute的方法抛出的异常也会被此处捕获
      logger.error('生成视频缩略图报错\n$fileAndThumbnailInfo',
          error: err, stackTrace: stack, tag: _logTag);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(thumbnail);
  }
}
