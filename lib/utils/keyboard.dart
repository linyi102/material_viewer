import 'package:flutter/material.dart';

class KeyboardUtil {
  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
