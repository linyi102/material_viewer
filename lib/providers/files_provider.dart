import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_viewer/constants/identity.dart';
import 'package:material_viewer/models/file_entity.dart';
import 'package:material_viewer/providers/path_provider.dart';
import 'package:material_viewer/repositories/files_repository.dart';
import 'package:material_viewer/utils/file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FilesNotifier extends AsyncNotifier<List<FileEntity>> {
  @override
  Future<List<FileEntity>> build() async {
    return ref.read(filesRepositoryProvider).getDisks();
  }

  Future<void> _enterDisks() async {
    ref.read(pathProvider.notifier).setPath(diskViewPathTag);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(filesRepositoryProvider).getDisks(),
    );
  }

  Future<bool> tryEnterDirectory(String path) async {
    final disks = await ref.read(filesRepositoryProvider).getDisks();
    final diskNames = disks.map((e) => e.name);
    if (Directory(path).existsSync() || diskNames.contains(path)) {
      enterDirectory(path);
      return true;
    }
    final pathWithColons = '$path:'.toUpperCase();
    if (diskNames.contains(pathWithColons)) {
      enterDirectory(pathWithColons);
      return true;
    }
    return false;
  }

  Future<void> enterDirectory(String path) async {
    ref.read(pathProvider.notifier).setPath(path);

    if (path == diskViewPathTag) {
      _enterDisks();
    } else {
      state = const AsyncLoading();
      state = await AsyncValue.guard(
        () => ref.read(filesRepositoryProvider).getFiles(path),
      );
    }
  }

  Future<void> goBack() async {
    final path = ref.read(pathProvider).path;
    if (FileUtil.hasNoParentDirectory(path)) {
      _enterDisks();
    } else {
      enterDirectory(Directory(path).parent.path);
    }
  }
}

final filesProvider =
    AsyncNotifierProvider<FilesNotifier, List<FileEntity>>(() {
  return FilesNotifier();
});
