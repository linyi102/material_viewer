import 'package:flutter/material.dart';

class ToastUtil {
  static Future<void> showMessage(BuildContext context, String? message) async {
    if (!context.mounted || message == null || message.isEmpty) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
