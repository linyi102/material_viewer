import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_logkit/logkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:material_viewer/pages/root_page.dart';
import 'package:material_viewer/providers/theme_provider.dart';
import 'package:material_viewer/utils/keyboard.dart';
import 'package:material_viewer/utils/logger.dart';
import 'package:material_viewer/utils/platform.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  runLogkitZonedGuarded(logger, () async {
    logger.info(
        '${Platform.resolvedExecutable}\nArguments:${Platform.executableArguments.toString()}');
    WidgetsFlutterBinding.ensureInitialized();
    MediaKit.ensureInitialized();
    Hive.init((await getApplicationDocumentsDirectory()).path);
    await Hive.openBox('settings');
    await _prepareWindow();

    runApp(const ProviderScope(child: MyApp()));
  });
}

Future<void> _prepareWindow() async {
  if (PlatformUtil.isMobile) return;

  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow(
    const WindowOptions(
      minimumSize: Size(300, 600),
      center: true,
      titleBarStyle: TitleBarStyle.hidden,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return ResponsiveApp(
      builder: (context) => MaterialApp(
        title: 'Flutter Demo',
        theme: generateTheme(),
        darkTheme: generateTheme(isDark: true),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        home: LogkitOverlayAttacher(
          logger: logger,
          child: const RootPage(),
        ),
        builder: (context, child) => GestureDetector(
          onTap: () => KeyboardUtil.removeFocus,
          child: child,
        ),
      ),
    );
  }

  ThemeData generateTheme({bool isDark = false}) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
        fontFamilyFallback: const ['HarmonyOS Sans SC', 'Microsoft YaHei'],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        cardTheme: const CardTheme(elevation: 0),
      );
}
