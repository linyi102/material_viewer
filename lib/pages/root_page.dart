import 'package:flutter/material.dart';
import 'package:material_viewer/pages/file_browser/file_browser.dart';
import 'package:material_viewer/pages/settings_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:window_manager/window_manager.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final tabs = [
    {
      'label': '文件',
      'icon': const Icon(Icons.folder_open),
      'selected_icon': const Icon(Icons.folder),
      'build_page': () => const FileBrowser(),
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
    {
      'label': '设置',
      'icon': const Icon(Icons.settings_outlined),
      'selected_icon': const Icon(Icons.settings),
      'build_page': () => const SettingsPage(),
    }
  ];
  int selectedIndex = 0;
  bool isExtended = true;

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
    final tab = tabs[selectedIndex];
    final buildPage = tab['build_page'];
    return Stack(
      children: [
        buildPage is Function
            ? buildPage()
            : Center(child: Text(tab['label'] as String)),
        _buildWindowCaption(),
      ],
    );
  }

  Align _buildWindowCaption() {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 40,
        child: WindowCaption(
          brightness: Theme.of(context).brightness,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
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
                      color: Theme.of(context).colorScheme.primary,
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
        margin: const EdgeInsets.symmetric(vertical: 16),
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
