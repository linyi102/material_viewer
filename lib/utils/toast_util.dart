import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ToastUtil {
  static Future<void> showMessage(BuildContext context, String? message) async {
    if (!context.mounted || message == null || message.isEmpty) return;

    final device = getDeviceType(MediaQuery.of(context).size);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: device == DeviceScreenType.mobile
            ? null
            : const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
