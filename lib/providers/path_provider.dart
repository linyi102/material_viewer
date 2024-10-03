import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_viewer/constants/identity.dart';
import 'package:material_viewer/utils/keyboard.dart';

class PathState {
  final TextEditingController pathInputController;
  final FocusNode pathInputFocusNode;
  final String path;
  final bool editingPath;

  PathState({
    required this.pathInputController,
    required this.pathInputFocusNode,
    required this.path,
    this.editingPath = false,
  });

  PathState copyWith({
    TextEditingController? pathInputController,
    FocusNode? pathInputFocusNode,
    String? path,
    bool? editingPath,
  }) {
    return PathState(
      pathInputController: pathInputController ?? this.pathInputController,
      pathInputFocusNode: pathInputFocusNode ?? this.pathInputFocusNode,
      path: path ?? this.path,
      editingPath: editingPath ?? this.editingPath,
    );
  }
}

class PathNotifier extends Notifier<PathState> {
  @override
  PathState build() {
    final pathInputController = TextEditingController();
    final focusNode = FocusNode();
    ref.onDispose(() {
      focusNode.dispose();
      pathInputController.dispose();
    });
    return PathState(
      pathInputController: pathInputController,
      pathInputFocusNode: focusNode,
      path: diskViewPathTag,
    );
  }

  void setPath(String path) {
    state = state.copyWith(path: path);
    state.pathInputController.text = path;
  }

  void focusEditing(BuildContext context) {
    state = state.copyWith(editingPath: true);
    state.pathInputFocusNode.requestFocus();
    state.pathInputController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: state.pathInputController.text.length,
    );
  }

  void unFocusEditing() {
    state = state.copyWith(editingPath: false);
    state.pathInputController.text = state.path;
    KeyboardUtil.removeFocus();
  }
}

final pathProvider =
    NotifierProvider<PathNotifier, PathState>(PathNotifier.new);

final isDiskViewProvider = StateProvider<bool>((ref) {
  return ref.watch(pathProvider).path == diskViewPathTag;
});
