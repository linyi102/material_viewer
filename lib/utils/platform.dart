import 'dart:io';

class PlatformUtil {
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isDesktop => !isMobile;
}
