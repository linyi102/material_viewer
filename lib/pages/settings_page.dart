import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_viewer/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(
            title: Text('设置'),
          ),
          SliverAnimatedList(
            initialItemCount: 1,
            itemBuilder: (context, index, animation) {
              return ListTile(
                title: const Text('主题模式'),
                subtitle: Text(ref.watch(themeModeProvider).label),
                onTap: () => _pickThemeMode(context, ref),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> _pickThemeMode(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('主题'),
        children: [
          ...List.generate(
            ThemeMode.values.length,
            (index) {
              final mode = ThemeMode.values[index];
              return RadioListTile<ThemeMode>(
                value: mode,
                groupValue: ref.watch(themeModeProvider),
                title: Text(mode.label),
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(themeModeProvider.notifier).changeThemeMode(value);
                  Navigator.pop(context);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
