import 'dart:io';

import 'package:material_viewer/utils/logger.dart';
import 'package:path/path.dart' as p;

String ffmpegExe =
    p.join(p.dirname(Platform.resolvedExecutable), 'bin', 'ffmpeg.exe');

class ThumbnailUtil {
  static Future<bool> generateVideoThumbnail({
    required String filePath,
    required String output,
    int scale = 600,
  }) async {
    try {
      final result = await Process.run(
        ffmpegExe,
        [
          '-ss',
          '00:00:01.00',
          '-i',
          filePath,
          '-y',
          '-vf',
          'scale=$scale:$scale/a',
          '-vframes',
          '1',
          output,
        ],
      );
      return result.exitCode == 0;
    } catch (err, stack) {
      logger.error('ffmpeg 生成缩略图异常：$err', stackTrace: stack);
      return false;
    }
  }
}
