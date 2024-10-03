import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logkit/logkit.dart';

/// 打包版本开启日志：
/// flutter build xxx --dart-define logging=true
const _enableLog = kDebugMode || bool.fromEnvironment('logging');

final logger = LogkitLogger(
  logkitSettings: LogkitSettings(
    disableAttachOverlay: !_enableLog,
    disableRecordLog: !_enableLog,
    printToConsole: true,
    maxLogCount: 500,
    entryIconBuilder: () => const _LogEntryIcon(),
    entryIconOffset: (screenSize, buttonSize) => Offset(
      12,
      screenSize.height - 30 - buttonSize.height,
    ),
  ),
);

class _LogEntryIcon extends StatelessWidget {
  const _LogEntryIcon();

  @override
  Widget build(BuildContext context) {
    return const FloatingActionButton(
      onPressed: null,
      child: Icon(Icons.bug_report),
    );
  }
}
