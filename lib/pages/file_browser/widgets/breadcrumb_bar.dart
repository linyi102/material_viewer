import 'package:flutter/material.dart';

class BreadcrumbBar<T> extends StatelessWidget {
  const BreadcrumbBar({
    super.key,
    required this.items,
    required this.onItemPressed,
  });
  final List<BreadcrumbItem<T>> items;
  final void Function(BreadcrumbItem value) onItemPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            items.length,
            (index) {
              final item = items[index];
              return Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: item.label,
                    ),
                    onTap: () {
                      onItemPressed(item);
                    },
                  ),
                  if (index < items.length - 1)
                    const Icon(Icons.chevron_right_outlined, size: 16)
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class BreadcrumbItem<T> {
  final Widget label;
  final T value;

  const BreadcrumbItem({
    required this.label,
    required this.value,
  });
}
