import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilesLayoutType { list, grid }

extension FilesLayoutTypeExtension on FilesLayoutType {
  String get label => switch (this) {
        FilesLayoutType.list => '列表',
        FilesLayoutType.grid => '网格',
      };

  IconData get icon => switch (this) {
        FilesLayoutType.list => Icons.view_list,
        FilesLayoutType.grid => Icons.view_module,
      };
}

class FilesUIState {
  final FilesLayoutType layoutType;
  const FilesUIState({
    required this.layoutType,
  });

  FilesUIState copyWith({
    FilesLayoutType? layoutType,
  }) {
    return FilesUIState(
      layoutType: layoutType ?? this.layoutType,
    );
  }
}

class FilesUINotifier extends Notifier<FilesUIState> {
  @override
  FilesUIState build() {
    return const FilesUIState(layoutType: FilesLayoutType.grid);
  }

  void updateLayoutType(FilesLayoutType type) {
    state = state.copyWith(layoutType: type);
  }

  void nextLayoutType() {
    const types = FilesLayoutType.values;
    int curIndex = types.indexOf(state.layoutType);
    int nextIndex = (curIndex + 1) % types.length;
    state = state.copyWith(layoutType: types[nextIndex]);
  }
}

final filesUIProvider =
    NotifierProvider<FilesUINotifier, FilesUIState>(FilesUINotifier.new);
