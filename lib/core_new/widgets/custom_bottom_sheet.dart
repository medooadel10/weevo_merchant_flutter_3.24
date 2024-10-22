import 'package:flutter/material.dart';

import 'custom_image.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<BottomSheetItem> items;

  const CustomBottomSheet({super.key, required this.items});

  static void show(BuildContext context, List<BottomSheetItem> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
        reverseCurve: Curves.easeInOut,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
      ),
      builder: (context) => CustomBottomSheet(items: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
              items[index].onTap();
            },
            child: ListTile(
              leading: items[index].icon != null
                  ? Icon(items[index].icon)
                  : CustomImage(
                      imageUrl: items[index].imageUrl,
                      height: 24,
                      width: 24,
                      isCircle: true,
                      fit: BoxFit.cover,
                      radius: 20,
                    ),
              title: Text(items[index].title),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[400],
        ),
      ),
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
