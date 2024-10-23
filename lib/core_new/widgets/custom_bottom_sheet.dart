import 'package:flutter/material.dart';

import 'custom_image.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<BottomSheetItem>? items;
  final List<Widget>? children;

  const CustomBottomSheet({
    super.key,
    this.items,
    this.children,
  });

  static void show(
    BuildContext context, {
    List<BottomSheetItem>? items,
    String? title,
    List<Widget>? children,
    bool isScrollControlled = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      enableDrag: true,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
        reverseCurve: Curves.easeInOut,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
      ),
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          CustomBottomSheet(items: items, children: children),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              itemCount: items?.length ?? children?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                if (children != null) {
                  return children![index];
                }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                    items![index].onTap();
                  },
                  child: ListTile(
                    leading: items![index].icon != null
                        ? Icon(items![index].icon)
                        : CustomImage(
                            imageUrl: items![index].imageUrl,
                            height: 24,
                            width: 24,
                            isCircle: true,
                            fit: BoxFit.cover,
                            radius: 20,
                          ),
                    title: Text(items![index].title),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomSheetItem {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final String? imageUrl;

  BottomSheetItem({
    required this.title,
    this.icon,
    required this.onTap,
    this.imageUrl,
  });
}
