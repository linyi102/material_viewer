import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_viewer/enums/file_type.dart';
import 'package:material_viewer/models/file_entity.dart';
import 'package:material_viewer/pages/file_browser/widgets/file_thumbnail.dart';
import 'package:material_viewer/pages/file_browser/widgets/path_breadcrumb.dart';
import 'package:material_viewer/pages/video_player/video_player.dart';
import 'package:material_viewer/providers/files_provider.dart';
import 'package:material_viewer/utils/file.dart';
import 'package:material_viewer/utils/windows.dart';
import 'package:material_viewer/widgets/data_status_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

class FileBrowser extends ConsumerStatefulWidget {
  const FileBrowser({super.key});

  @override
  ConsumerState<FileBrowser> createState() => _FileBrowserState();
}

class _FileBrowserState extends ConsumerState<FileBrowser> {
  final leadingWidth = 40.0;
  final leadingHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 40, 12, 0),
            child: AppBar(title: const Text('文件')),
          ),
          const PathBreadCrumb(),
          Expanded(
            child: ref.watch(filesProvider).when(
                  data: (data) => _buildFileListView(data),
                  error: (error, stackTrace) =>
                      ErrorView(message: error.toString()),
                  loading: () => const LoadingView(),
                ),
          )
        ],
      ),
    );
  }

  ListView _buildFileListView(List<FileEntity> files) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 40),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: leadingWidth,
              height: leadingHeight,
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
                  DateFormat('yyyy-MM-dd hh:mm:ss').format(file.stat.modified),
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
          onTap: () {
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
          },
        );
      },
    );
  }
}
