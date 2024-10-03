// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final success = await compute(
        _generateVideoThumbnail,
        _SendMessage(
            token: RootIsolateToken.instance!,
            filePath: widget.file.path,
            output: output,
            format: format),
      );
      if (success) {
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

Future<bool> _generateVideoThumbnail(_SendMessage message) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(message.token);

  final plugin = FcNativeVideoThumbnail();
  return plugin.getVideoThumbnail(
    srcFile: message.filePath,
    destFile: message.output,
    width: 300,
    height: 300,
    format: message.format,
    quality: 90,
  );
}

class _SendMessage {
  RootIsolateToken token;
  String filePath;
  String output;
  String format;
  _SendMessage({
    required this.token,
    required this.filePath,
    required this.output,
    required this.format,
  });
}
