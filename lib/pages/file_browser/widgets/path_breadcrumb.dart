import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_viewer/constants/identity.dart';
import 'package:material_viewer/models/directory_entity.dart';
import 'package:material_viewer/pages/file_browser/widgets/breadcrumb_bar.dart';
import 'package:material_viewer/providers/files_provider.dart';
import 'package:material_viewer/providers/path_provider.dart';
import 'package:material_viewer/utils/file.dart';
import 'package:material_viewer/utils/toast_util.dart';

class PathBreadCrumb extends ConsumerStatefulWidget {
  const PathBreadCrumb({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PathBreadCrumbState();
}

class _PathBreadCrumbState extends ConsumerState<PathBreadCrumb> {
  @override
  Widget build(BuildContext context) {
    final pathInputController = ref.watch(pathProvider).pathInputController;
    final editingPath = ref.watch(pathProvider).editingPath;
    final pathController = ref.read(pathProvider.notifier);
    final filesController = ref.read(filesProvider.notifier);

    Widget buildPathInputField() {
      return TextField(
        focusNode: ref.watch(pathProvider).pathInputFocusNode,
        controller: pathInputController,
        onEditingComplete: () async {
          final input = pathInputController.text.trim();
          if (await filesController.tryEnterDirectory(input)) {
            pathController.unFocusEditing();
          } else {
            if (context.mounted) {
              ToastUtil.showMessage(context, 'Disk or Directory not found!');
            }
          }
        },
        onTapOutside: (_) {
          pathController.unFocusEditing();
        },
      );
    }

    Widget buildBreadcrumb() {
      final List<BreadcrumbItem<String>> items = [];
      final directoryPath = ref.watch(pathProvider).path;

      var directory = DirectoryEntity.fromPath(directoryPath);
      while (true) {
        if (directoryPath == diskViewPathTag) break;

        items.add(BreadcrumbItem(
          label: Text(directory.name),
          value: directory.path,
        ));

        if (FileUtil.hasNoParentDirectory(directory.path)) {
          break;
        } else {
          directory = DirectoryEntity.fromPath(directory.raw.parent.path);
        }
      }
      items
          .add(const BreadcrumbItem(label: Text('PC'), value: diskViewPathTag));
      return BreadcrumbBar(
        items: items.reversed.toList(),
        onItemPressed: (item) {
          filesController.enterDirectory(item.value);
        },
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: ref.watch(isDiskViewProvider)
                ? null
                : () => filesController.goBack(),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: editingPath
                  ? null
                  : () => pathController.focusEditing(context),
              child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // 避免显示输入框隐藏面包屑时高度发生变化
                      const IgnorePointer(
                          ignoring: true,
                          child: Opacity(
                              opacity: 0, child: TextField(readOnly: true))),
                      Offstage(
                          offstage: !editingPath, child: buildPathInputField()),
                      Offstage(offstage: editingPath, child: buildBreadcrumb()),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
