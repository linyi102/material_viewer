import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_viewer/utils/toast_util.dart';

class WindowsUtil {
  /// https://stackoverflow.com/questions/66532037/any-way-to-list-physical-disk-on-windows-with-flutter-dart
  static Future<List<String>> getDisks() async {
    return LineSplitter.split((await Process.run(
                'wmic', ['logicaldisk', 'get', 'caption'],
                stdoutEncoding: const SystemEncoding()))
            .stdout as String)
        .map((string) => string.trim())
        .where((string) => string.isNotEmpty)
        .skip(1)
        .toList();
  }

  static Future<bool> openFile(BuildContext context, String path) async {
    try {
      final result = await Process.run('cmd', ['/c', 'start', '', path]);
      final success = result.exitCode == 0;
      if (!success && context.mounted) {
        ToastUtil.showMessage(context, 'Open $path fail!');
      }
      return success;
    } catch (e) {
      if (context.mounted) {
        ToastUtil.showMessage(context, 'Open $path error: $e');
      }
      return false;
    }
  }
}
