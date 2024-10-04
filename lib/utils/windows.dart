import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_viewer/utils/logger.dart';
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

  /// 文件资源管理器打开文件夹
  static Future<bool> openFolder(String path) async {
    try {
      final result = await Process.run('cmd', ['/c', 'explorer', path]);
      final isSuccess = result.exitCode == 0;
      return isSuccess;
    } catch (err, stack) {
      logger.error('打开文件夹 $path 失败：$err', stackTrace: stack);
      return false;
    }
  }

  /// 文件资源管理器定位文件
  static Future<bool> locateFile(String path) async {
    try {
      final result =
          await Process.run('cmd', ['/c', 'explorer', '/select,', path]);
      final isSuccess = result.exitCode == 0;
      return isSuccess;
    } catch (err, stack) {
      logger.error('定位文件 $path 失败：$err', stackTrace: stack);
      return false;
    }
  }
}
