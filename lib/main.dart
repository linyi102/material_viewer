import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamilyFallback: const ['HarmonyOS Sans SC', 'Microsoft YaHei'],
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final tabs = [
    {
      'label': '文件',
      'icon': const Icon(Icons.folder_open),
      'selected_icon': const Icon(Icons.folder),
    },
    {
      'label': '最近',
      'icon': const Icon(Icons.access_time),
      'selected_icon': const Icon(Icons.access_time_filled),
    },
    {
      'label': '图片',
      'icon': const Icon(Icons.image_outlined),
      'selected_icon': const Icon(Icons.image),
    },
    {
      'label': '音乐',
      'icon': const Icon(Icons.library_music_outlined),
      'selected_icon': const Icon(Icons.library_music),
    },
    {
      'label': '视频',
      'icon': const Icon(Icons.video_collection_outlined),
      'selected_icon': const Icon(Icons.video_collection),
    },
  ];
  int selectedIndex = 0;
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => Scaffold(
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(),
      ),
      tablet: (_) => Scaffold(
        body: Row(
          children: [
            isExtended ? _buildDrawer() : _buildRail(),
            if (!isExtended) const VerticalDivider(width: 0.8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return const Scaffold();
  }

  NavigationBar _buildBottomBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
        });
      },
      destinations: [
        ...List.generate(tabs.length, (index) {
          final tab = tabs[index];
          return NavigationDestination(
            icon: tab[selectedIndex == index ? 'selected_icon' : 'icon']
                as Widget,
            label: tab['label'] as String,
          );
        })
      ],
    );
  }

  NavigationDrawer _buildDrawer() {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
        });
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Text(
                'VIEWER',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
              ),
              const Spacer(),
              _buildExtendButton()
            ],
          ),
        ),
        ...List.generate(tabs.length, (index) {
          final tab = tabs[index];
          return NavigationDrawerDestination(
            icon: tab[selectedIndex == index ? 'selected_icon' : 'icon']
                as Widget,
            label: Text(tab['label'] as String),
          );
        })
      ],
    );
  }

  NavigationRail _buildRail() {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      // extended: true,
      elevation: 100,
      destinations: [
        ...List.generate(tabs.length, (index) {
          final tab = tabs[index];
          return NavigationRailDestination(
            icon: tab[selectedIndex == index ? 'selected_icon' : 'icon']
                as Widget,
            label: Text(tab['label'] as String),
          );
        })
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
        });
      },
      leading: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: _buildExtendButton(),
      ),
    );
  }

  Widget _buildExtendButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          isExtended = !isExtended;
        });
      },
      icon: Icon(isExtended ? Icons.menu_open : Icons.menu),
    );
  }
}
