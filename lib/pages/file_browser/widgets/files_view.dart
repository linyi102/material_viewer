import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_viewer/enums/file_type.dart';
import 'package:material_viewer/models/file_entity.dart';
import 'package:material_viewer/pages/file_browser/widgets/file_thumbnail.dart';
import 'package:material_viewer/pages/video_player/video_player.dart';
import 'package:material_viewer/providers/files_provider.dart';
import 'package:material_viewer/providers/files_ui_provider.dart';
import 'package:material_viewer/utils/file.dart';
import 'package:material_viewer/utils/windows.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

class FilesView extends ConsumerWidget {
  const FilesView(this.files, {super.key});
  final List<FileEntity> files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnailRadius = BorderRadius.circular(6);

    void onTapFileItem(FileEntity file) {
      if (file.isDirectory) {
        ref.read(filesProvider.notifier).enterDirectory(file.path);
        return;
      }
      if (file.type != FileType.video) {
        WindowsUtil.openFile(context, file.path);
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(path: file.path),
        ),
      );
    }

    ListView buildListView() {
      const thumbnailWidth = 40.0;
      const thumbnailHeight = 40.0;

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 40),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];

          return ListTile(
            leading: ClipRRect(
              borderRadius: thumbnailRadius,
              child: SizedBox(
                width: thumbnailWidth,
                height: thumbnailHeight,
                child: FileThumbnail(file: file.raw, type: file.type),
              ),
            ),
            visualDensity: VisualDensity.standard,
            title: Text(
              p.basename(file.path),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    intl.DateFormat('yyyy-MM-dd hh:mm:ss')
                        .format(file.stat.modified),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: file.isFile
                      ? Text(
                          FileUtil.getReadableSize(file.stat.size),
                          textAlign: TextAlign.right,
                        )
                      : null,
                ),
              ],
            ),
            onTap: () => onTapFileItem(file),
          );
        },
      );
    }

    Widget buildGridView() {
      const itemHeight = 160.0,
          nameHeight = 50.0,
          itemPadding = 8.0,
          thumbnailHeight = itemHeight - nameHeight - itemPadding * 2;
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: itemHeight,
          maxCrossAxisExtent: 160,
        ),
        itemCount: files.length,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        itemBuilder: (context, index) {
          final file = files[index];
          return InkWell(
            borderRadius: thumbnailRadius,
            onTap: () => onTapFileItem(file),
            child: Container(
              padding: const EdgeInsets.all(itemPadding),
              child: Column(
                children: [
                  SizedBox(
                    height: thumbnailHeight,
                    child: ClipRRect(
                      borderRadius: thumbnailRadius,
                      child: FileThumbnail(file: file.raw, type: file.type),
                    ),
                  ),
                  SizedBox(
                    height: nameHeight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Text(
                        file.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return switch (ref.watch(filesUIProvider).layoutType) {
      FilesLayoutType.grid => buildGridView(),
      FilesLayoutType.list => buildListView(),
    };
  }
}
