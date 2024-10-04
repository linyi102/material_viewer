import 'package:flutter/material.dart';
import 'package:material_viewer/pages/file_browser/widgets/files_view.dart';
import 'package:material_viewer/pages/file_browser/widgets/path_breadcrumb.dart';
import 'package:material_viewer/providers/files_provider.dart';
import 'package:material_viewer/providers/files_ui_provider.dart';
import 'package:material_viewer/providers/path_provider.dart';
import 'package:material_viewer/utils/windows.dart';
import 'package:material_viewer/widgets/data_status_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileBrowser extends ConsumerStatefulWidget {
  const FileBrowser({super.key});

  @override
  ConsumerState<FileBrowser> createState() => _FileBrowserState();
}

class _FileBrowserState extends ConsumerState<FileBrowser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 40, 12, 0),
            child: AppBar(
              title: const Text('文件'),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                _buildLayoutButton(),
                _buildMoreButton()
              ],
            ),
          ),
          const PathBreadCrumb(),
          Expanded(
            child: ref.watch(filesProvider).when(
                  data: (data) => FilesView(data),
                  error: (error, stackTrace) =>
                      ErrorView(message: error.toString()),
                  loading: () => const LoadingView(),
                ),
          )
        ],
      ),
    );
  }

  Widget _buildLayoutButton() {
    final selectedType = ref.watch(filesUIProvider).layoutType;

    return PopupMenuButton<FilesLayoutType>(
      icon: const Icon(Icons.space_dashboard_outlined),
      itemBuilder: (BuildContext context) {
        return [
          for (final type in FilesLayoutType.values)
            CheckedPopupMenuItem(
              value: type,
              checked: type == selectedType,
              child: Text(type.label),
            )
        ];
      },
      initialValue: selectedType,
      onSelected: (value) {
        ref.read(filesUIProvider.notifier).updateLayoutType(value);
      },
    );
  }

  Widget _buildMoreButton() {
    return PopupMenuButton<_MoreAction>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: _MoreAction.openExplorer,
            child: ListTile(
              leading: Icon(Icons.open_in_new),
              title: Text('打开文件资源管理器'),
            ),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case _MoreAction.openExplorer:
            WindowsUtil.openFolder(ref.read(pathProvider).path);
            break;
          default:
        }
      },
    );
  }
}

enum _MoreAction {
  openExplorer,
}
